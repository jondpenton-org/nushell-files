## Commands
# Builds list of flag strings to pass to command
export def build-flags [
  flags: record   # Record with key of flag to its value
] {
  $flags
    | transpose key value
    | par-each { |it|
        $it.value | describe
          | if $in == "bool" && $it.value {
              $'--($it.key)'
            } else if $in in ['string', 'int'] {
              [$'--($it.key)', $it.value]
            }
      }
    | flatten
}

# Run a block and specify a block to run on success or failure
export def do-when [
  block: block
  --on-success (-s): block    # Runs on $block success
  --on-failure (-f): block    # Runs on $block failure
] {
  let block-exit-code = do { do $block; $env.LAST_EXIT_CODE }

  if (not ($on-success | empty?)) && $block-exit-code == 0 {
    do $on-success
  } else if ($block-exit-code != 0) {
    if (not ($on-failure | empty?)) {
      do $on-failure
    }

    sh -c $'exit ($block-exit-code)'
  }
}

# Run a series of blocks
export def do-blocks [
  ...blocks: block    # Blocks to run in succession. If one fails, later blocks will not run.
] {
  do-blocks-list $blocks
}

# Run a list of blocks
export def do-blocks-list [
  blocks: any   # List of blocks
] {
  let chained-blocks = (
    $blocks | reduce { |it, acc|
      { do-when $acc --on-success $it }
    }
  )

  do $chained-blocks
}

# Kills all nu shells
export def nu-ko [] {
  ps | par-each { |it|
    $it
      | get name
      | path parse
      | get stem
      | if ($in == 'nu') {
          kill --force $it.pid
        }
  }
}

export def nu-reload [] {
  let nu-path = (which nu | get path.0)

  exec $nu-path '-c' $'cd "($env.PWD)"; ($nu-path)'
}

# Repeat block # of times
export def repeat [
  times: int    # Times to repeat $block
  block: block
] {
  for it in 1..$times $block
}

# Sleep while condition true
export def sleep-while [
  condition: block
  sleep: duration = 100ms
] {
  let original-in = $in

  if do $condition {
    sleep $sleep;
    sleep-while $condition $sleep;
  }

  $original-in
}

export def table-into-record [
  key: string = "key"
  value: string = "value"
] {
  select $key $value | transpose -r | get 0
}

# Returns record with no duplicate keys
export def uniq-record [] {
  flatten | get 0
}
