use modules/git/git-root.nu

export def 'nu-complete nx projects' [] {
  let workspace_path = git-root | path join workspace.json
  let projects = (
    if ($workspace_path | path exists) {
      open $workspace_path
        | $in.projects
        | columns
    } else {
      let projects_raw = (
        if (git-root | path join pnpm-workspace.yaml | path exists) {
          ^pnpm exec nx show projects
        } else {
          ^nx show projects
        }
      )

      $projects_raw | lines
    }
  )

  $projects | sort
}
