use modules/git/git-root.nu
use std

export def 'nu-complete nx all targets' [] {
  let workspace_path = git-root | path join workspace.json
  let project_targets = (
    if ($workspace_path | path exists) {
      open $workspace_path
        | $in.projects
        | transpose project path
        | each {
            $in.path
              | path join project.json
              | open
              | $in.targets
              | columns
          }
    } else {
      let search_folders = (
        git-root
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
                  git-root | path join $search_folder $project project.json
                }
              | std iter find { path exists }
              | open
              | $in.targets
              | columns
          }
    }
  )

  $project_targets | uniq | sort
}
