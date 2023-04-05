export def "nu-complete nx output-style" [] {
  [`compact`, `dynamic`, `static`, `stream`, `stream-without-prefixes`] | sort
}

export def "nu-complete nx all targets" [] {
  let project_targets = (
    do {
      let workspace_path = (git-root | path join workspace.json)

      if ($workspace_path | path exists) {
        open $workspace_path
          | get projects
          | transpose project path
          | par-each { |it|
              get path
                | path join project.json
                | open $in
                | get targets
                | columns
            }
      } else {
        let search_folders = (
          git-root
            | path join nx.json
            | open $in
            | get workspaceLayout
            | values
        )

        pnpm exec nx show projects
          | lines
          | par-each { |project|
              $search_folders
                | par-each { |search_folder|
                    git-root
                      | path join $search_folder $project project.json
                      | when { path exists | not $in } null
                  }
                | first
                | open $in
                | get targets
                | columns
            }
      }
    }
  )

  $project_targets | uniq | sort
}

export def "nu-complete nx project targets" [] {
  let project_targets = (
    do {
      let workspace_path = (git-root | path join workspace.json)

      if ($workspace_path | path exists) {
        open $workspace_path
          | get projects
          | transpose project path
          | par-each { |it|
              get path
                | path join project.json
                | open $in
                | get targets
                | columns
                | par-each { |target| $'($it | get project):($target)' }
            }
      } else {
        let search_folders = (
          git-root
            | path join nx.json
            | open $in
            | get workspaceLayout
            | values
        )

        pnpm exec nx show projects
          | lines
          | par-each { |project|
              $search_folders
                | par-each { |search_folder|
                    git-root
                      | path join $search_folder $project project.json
                      | when { path exists | not $in } null
                  }
                | first
                | open $in
                | get targets
                | columns
                | par-each { |target| $'($project):($target)' }
            }
      }
    }
  )

  $project_targets | sort
}

export def "nu-complete nx projects" [] {
  let projects = (
    do {
      let workspace_path = (git-root | path join workspace.json)

      if ($workspace_path | path exists) {
        open $workspace_path
          | get projects
          | columns
      } else {
        let projects_raw = (
          if (git-root | path join pnpm-workspace.yaml | path exists) {
            pnpm exec nx show projects
          } else {
            nx show projects
          }
        )

        $projects_raw | lines
      }
    }
  )

  $projects | sort
}
