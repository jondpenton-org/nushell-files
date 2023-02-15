use helpers.completion.nu [`nu-complete overlay-list filters`]

# Runs benchmark number of $times and averages them together
export def benchmark-repeat [
  times: int      # Number of times benchmark is ran
  block: block    # Block passed to `benchmark`
] {
  repeat $times { benchmark $block } | math avg
}

# Builds list of flag strings to pass to command
export def build-flags [
  flags: record   # Record with key of flag to its value
] {
  $flags
    | transpose key value
    | par-each { |it|
        let formatted_key = $'--($it | get key)'
        let type = ($it | get value | describe)

        if $type == bool and ($it | get value) {
          $formatted_key
        } else if $type in [`float`, `string`, `int`] {
          [$formatted_key, ($it | get value)]
        }
      }
    | flatten
}

export def external-command-exists [
  command_name: string
] {
  which --all $command_name | any { get path | str starts-with / }
}

# Kills all nu shells
export def nu-kill-all [] {
  ps | par-each { |it|
    get name
      | path parse
      | get stem
      | if $in == nu {
          kill --force ($it | get pid)
        }
  }
}

export def nu-reload [] {
  let nu_path = (
    which nu | get path.0
  )

  exec $nu_path `--commands` $'cd ($env | get PWD | to json); ($nu_path) --login'
}

# List and filter all overlays
export def overlay-list [
  --filter: string@"nu-complete overlay-list filters" = `active`   # Filter what overlays are shown
] {
  let active_overlays = overlay list

  if $filter == active {
    return $active_overlays
  }

  let all_overlays = (
    $env
      | get NU_DIR
      | path join scripts
      | ls $in
      | par-each { |it|
          if ($it | get type) == file and (($it | get name) ends-with .nu) {
            get name
              | path basename
              | str replace --string .nu ``
          }
        }
  )

  if $filter == all {
    return ($all_overlays | sort)
  }

  if $filter == inactive {
    $all_overlays
      | par-each { |it|
          if not ($it in $active_overlays) {
            $it
          }
        }
      | sort
  }
}

# Repeat block # of times
export def repeat [
  times: int    # Times to repeat $block
  block: closure
] {
  1..$times | each $block
}

# Sleep while condition true
export def sleep-while [
  condition: closure              # Condition to check

  --interval: duration = 100ms    # How often `condition` is checked
] {
  while (do $condition) { sleep $interval }
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

# When predicate evaluates to `true`, returns consequent or `do $consequent`
export def when [
  predicate: closure    # Closure that returns `bool`. Evaluated as a `do` closure with input passed as parameter and input.
  consequent: any       # Any value; If closure, evaluated as a `do` closure with input passed as parameter and input.
] {
  let input = $in

  if ($input | do $predicate $input) != true {
    return $input
  }

  if ($consequent | describe) == `closure` {
    return ($input | do $consequent $input)
  }

  return $consequent
}
