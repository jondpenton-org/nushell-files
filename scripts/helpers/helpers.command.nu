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
    | par-each { |flag|
        let formatted_key = $'--($flag.key)'
        let type = ($flag.value | describe)

        if $type == `bool` and $flag.value {
          $formatted_key
        } else if $type in [`float`, `string`, `int`] {
          [$formatted_key, $flag.value]
        }
      }
    | flatten
}

export def external-command-exists [
  command_name: string
] {
  which --all $command_name | any { |row| $row.path starts-with `/` }
}

# Kills all nu shells
export def nu-kill-all [] {
  ps | par-each { |process|
    $process.name
      | path parse
      | if $in.stem == `nu` {
          kill --force $process.pid
        }
  }
}

export def nu-reload [] {
  let nu_path = (
    which `nu` | $in.path.0
  )

  exec $nu_path `--commands` $'cd ($env.PWD | to json); ($nu_path) --login'
}

# List and filter all overlays
export def overlay-list [
  --filter: string@"nu-complete overlay-list filters" = `active`   # Filter what overlays are shown
] {
  let active_overlays = overlay list

  if $filter == `active` {
    return $active_overlays
  }

  let all_overlays = (
    $env.NU_DIR
      | path join `scripts`
      | ls $in
      | par-each { |row|
          if $row.type != file or (not ($row.name ends-with .nu)) {
            return
          }

          $row.name | path basename | str replace --string `.nu` ``
        }
  )

  if $filter == `all` {
    return ($all_overlays | sort)
  }

  if $filter == `inactive` {
    $all_overlays
      | par-each { |overlay|
          if $overlay in $active_overlays {
            return
          }

          $overlay
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
