use std

export def 'nu-complete nx project targets' [] {
  let workspace_path = ^git-root | path join workspace.json
  let project_targets = (
    if ($workspace_path | path exists) {
      open $workspace_path
        | $in.projects
        | transpose project path
        | each { |it|
            $it.path
              | path join project.json
              | open
              | $in.targets
              | columns
              | each { $"($it.project):($in)" }
          }
    } else {
      let search_folders = (
        ^git-root
          | path join nx.json
          | open
          | $in.workspaceLayout
          | values
      )

      ^pnpm exec nx show projects
        | lines
        | each { |project|
            $search_folders
              | each { |search_folder|
                  ^git-root | path join $search_folder $project project.json
                }
              | std iter find { path exists }
              | open
              | $in.targets
              | columns
              | each { $"($project):($in)" }
          }
        | flatten
    }
  )

  $project_targets | sort
}
