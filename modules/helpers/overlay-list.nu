# List and filter all overlays
export def main [
  --filter: string@'nu-complete overlay-list filters' = active # Filter what overlays are shown
] {
  let active_overlays = (overlay list)

  if $filter == active {
    return $active_overlays
  }

  let all_overlays = (
    # TODO: Use $env.NU_LIB_DIRS
    ls ($env.NU_DIR | path join scripts)
      | where type == file and name ends-with .nu
      | $in.name
      | path basename
      | str replace --string .nu ''
  )

  if $filter == 'all' {
    return ($all_overlays | sort)
  }

  if $filter == inactive {
    $all_overlays
      | filter { $in not-in $active_overlays }
      | sort
  }
}

def 'nu-complete overlay-list filters' [] {
  [active, all, inactive]
}
