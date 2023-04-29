use ../git.nu [
  git-root,
]
use nx.completion.nu [
  `nu-complete nx all targets`,
  `nu-complete nx output-style`,
  `nu-complete nx project targets`,
  `nu-complete nx projects`,
]

# TODO: Remove
def "nu-complete nx all targets" [] {
  let project_targets = (
    do {
      let workspace_path = (git-root | path join workspace.json)

      if ($workspace_path | path exists) {
        open $workspace_path
          | $in.projects
          | transpose project path
          | par-each {
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
          | par-each { |project|
              $search_folders
                | each { |search_folder|
                    git-root
                      | path join $search_folder $project project.json
                      | filter { path exists }
                  }
                | $in.0
                | open
                | $in.targets
                | columns
            }
      }
    }
  )

  $project_targets | uniq | sort
}

# TODO: Remove
def "nu-complete nx output-style" [] {
  [`compact`, `dynamic`, `static`, `stream`, `stream-without-prefixes`] | sort
}

# TODO: Remove
def "nu-complete nx project targets" [] {
  let project_targets = (
    do {
      let workspace_path = (git-root | path join workspace.json)

      if ($workspace_path | path exists) {
        open $workspace_path
          | $in.projects
          | transpose project path
          | par-each { |it|
              $it.path
                | path join project.json
                | open
                | $in.targets
                | columns
                | each { |target| $"($it.project):($target)" }
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
          | par-each { |project|
              $search_folders
                | each { |search_folder|
                    git-root
                      | path join $search_folder $project project.json
                      | filter { path exists }
                  }
                | $in.0
                | open
                | $in.targets
                | columns
                | each { |target| $"($project):($target)" }
            }
      }
    }
  )

  $project_targets | sort
}

# TODO: Remove
def "nu-complete nx projects" [] {
  let projects = (
    do {
      let workspace_path = (git-root | path join workspace.json)

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
    }
  )

  $projects | sort
}

# Run a target for a project
export extern "pnpm exec nx run" [
  target: string@'nu-complete nx project targets'

  --configuration (-c): string                            # Target configuration
  --help                                                  # Show help
  --nx-bail                                               # Stop command execution after the first failed task
  --nx-ignore-cycles                                      # Ignore cycles in the task graph
  --output-style: string@'nu-complete nx output-style'    # Defines how Nx emits outputs tasks logs
  --prod                                                  # Use the production configuration
  --project: string@'nu-complete nx projects'             # Target project
  --skip-nx-cache                                         # Don't use cache
  --version                                               # Show version number
]

# Run target for affected projects
export extern "pnx affected" [
  --all # All projects
  --base: string # Base of the current branch (usually main)
  --configuration (-c): string # This is the configuration to use when performing tasks on projects
  --exclude: string@'nu-complete nx projects' # Exclude certain projects from being processed
  --files: string # Change the way Nx is calculating the affected command by providing directly changed files, list of files delimited by commas or spaces
  --head: string # Latest commit of the current branch (usually HEAD)
  --nx-bail # Stop command execution after the first failed task
  --nx-ignore-cycles # Ignore cycles in the task graph
  --output-style: string@'nu-complete nx output-style' # Defines how Nx emits outputs tasks logs
  --parallel: int # Max number of parallel processes [default is 3]
  --runner: string # This is the name of the tasks runner configured in nx.json
  --skip-nx-cache # Rerun the tasks even when the results are available in the cache
  --target (-t): string@'nu-complete nx all targets' # Tasks to run for affected projects
  --uncommitted # Uncommitted changes
  --untracked # Untracked changes
  --verbose # Prints additional information about the commands (e.g., stack traces)
  --version # Show version number
]

# Run a target for a project
export extern "pnx run" [
  target: string@'nu-complete nx project targets'

  --configuration (-c): string                            # Target configuration
  --help                                                  # Show help
  --nx-bail                                               # Stop command execution after the first failed task
  --nx-ignore-cycles                                      # Ignore cycles in the task graph
  --output-style: string@'nu-complete nx output-style'    # Defines how Nx emits outputs tasks logs
  --prod                                                  # Use the production configuration
  --project: string@'nu-complete nx projects'             # Target project
  --skip-nx-cache                                         # Don't use cache
  --version                                               # Show version number
]

# Run target for multiple listed projects
export extern "pnx run-many" [
  --target (-t): string@'nu-complete nx all targets' # Tasks to run for affected projects
]
