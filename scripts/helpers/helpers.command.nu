use helpers.completion.nu ["nu-complete overlay-list filters"]

# Runs benchmark number of $times and averages them together
export def benchmark-repeat [
  times: int      # Number of times benchmark is ran
  block: block    # Block passed to `benchmark`
] {
  let benchmarks = (
    repeat $times { benchmark $block }
  )

  $benchmarks
    | each { |it| $it / 1ns } # Duration to int
    | math avg
    | math ceil
    | into int
    | $in * 1ns # Int to duration
}

# Builds list of flag strings to pass to command
export def build-flags [
  flags: record   # Record with key of flag to its value
] {
  $flags
    | transpose key value
    | par-each { |it|
        $it.value
          | describe
          | if $in == `bool` && $it.value {
              $"--($it.key)"
            } else if $in in [`string`, `int`] {
              [$"--($it.key)", $it.value]
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
  let block_exit_code = do { do $block; $env.LAST_EXIT_CODE }

  if (not ($on_success | is-empty)) && $block_exit_code == 0 {
    do $on_success
  } else if ($block_exit_code != 0) {
    if (not ($on_failure | is-empty)) {
      do $on_failure
    }

    sh `-c` $"exit ($block_exit_code)"
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
  let chained_blocks = (
    $blocks | reduce { |it, acc|
      { do-when $acc --on-success $it }
    }
  )

  do $chained_blocks
}

export def external-command-exists [
  command_name: string
] {
  not (
    which --all $command_name
      | where path != `Nushell custom command`
      | is-empty
  )
}

# Kills all nu shells
export def nu-ko [] {
  ps | par-each { |it|
    $it.name
      | path parse
      | if $in.stem == `nu` {
          kill --force $it.pid
        }
  }
}

export def nu-reload [] {
  let nu_path = (
    which `nu` | $in.path.0
  )

  exec $nu_path `--commands` $"cd ($env.PWD | to json); ($nu_path) --login"
}

# List and filter all overlays
export def overlay-list [
  --filter: string@"nu-complete overlay-list filters" = `active`   # Filter what overlays are shown
] {
  let active_overlays = overlay list

  if $filter == `active` {
    $active_overlays
  } else {
    let all_overlays = (
      $env.NU_DIR
        | path join `scripts`
        | ls $in
        | $in.name
        | path basename
        | str replace --string `.nu` ``
    )

    if $filter == `all` {
      $all_overlays
    } else if $filter == `inactive` {
      $all_overlays
        | par-each { |overlay|
            if $overlay not-in $active_overlays {
              $overlay
            }
          }
        | sort
    }
  }
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
  let original_in = $in

  if do $condition {
    sleep $sleep;
    sleep-while $condition $sleep;
  }

  $original_in
}

export def table-into-record [
  key: string = `key`
  value: string = `value`
] {
  select $key $value
    | transpose --header-row
    | get --ignore-errors 0
    | default {}
}
