use helpers.completion.nu [`nu-complete overlay-list filters`]

# Runs timeit number of $times and averages them together
export def timeit-repeat [
  times: int          # Number of times timeit is ran
  closure: closure    # Closure passed to `timeit`
] {
  repeat $times { timeit $closure } | math avg
}

# Builds list of flag strings to pass to command
export def build-flags [
  flags: record   # Record with key of flag to its value
] {
  $flags
    | transpose key value
    | each { |it|
        let formatted_key = $'--($it.key)'

        match ($it.value | describe) {
          `bool` => {
            if $it.value {
              $formatted_key
            }
          },
          `float` | `int` | `string` => [$formatted_key, $it.value],
          `list<string>` => ($it.value | prepend $formatted_key)
        }
      }
    | flatten
}

export def external-command-exists [
  command_name: string
] {
  which --all $command_name | any { || $in.path starts-with / }
}

# Kills all nu shells
export def nu-kill-all [] {
  ps | par-each { |it|
    $in.name
      | path parse
      | if $in.stem == nu {
          kill --force $it.pid
        }
  }
}

export def nu-reload [] {
  let nu_path = (
    which nu | $in.0.path
  )

  exec $nu_path `--commands` $'cd ($env.PWD | to json); ($nu_path) --login'
}

# List and filter all overlays
export def overlay-list [
  --filter: string@"nu-complete overlay-list filters" = `active`   # Filter what overlays are shown
] {
  let active_overlays = (overlay list)

  if $filter == active {
    return $active_overlays
  }

  let all_overlays = (
    $env.NU_DIR
      | path join scripts
      | ls $in
      | par-each { |it|
          if $it.type == file and $it.name ends-with .nu {
            $in.name
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
          when { || $in in $active_overlays } null
        }
      | sort
  }
}

# Run a closure on each row of the input list in parallel, mapping to a new list with the results in order.
export def par-map [
  --threads (-t): int # the number of threads to use

  closure: closure # the closure to run
] {
  enumerate
    | par-each { |it|
        update item ($it.item | do $closure $it.item)
      }
    | sort-by index
    | $in.item
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
    | $in.0?
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

  match ($consequent | describe) {
    `closure` => ($input | do $consequent $input)
    _ => $consequent
  }
}
