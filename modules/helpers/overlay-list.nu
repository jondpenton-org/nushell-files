# List and filter all overlays
export def main [
  --filter: string@'nu-complete overlay-list filters' = active # Filter what overlays are shown
]: any -> list<string> {
  let active_overlays = overlay list

  if $filter == active {
    return $active_overlays
  }

  let all_overlays = (
    # TODO: Use $env.NU_LIB_DIRS
    ls ($env.NU_DIR | path join scripts)
      | where type == file and name ends-with .nu
      | $in.name
      | path basename
      | str replace .nu ''
  )

  match $filter {
    all => ($all_overlays | sort),
    inactive => {
      $all_overlays | filter { $in not-in $active_overlays } | sort
    },
  }
}

def 'nu-complete overlay-list filters' []: any -> list<string> {
  [active, all, inactive]
}
