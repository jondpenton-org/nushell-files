use nx.completion.nu [
  `nu-complete nx all targets`,
  `nu-complete nx output-style`,
  `nu-complete nx project targets`,
  `nu-complete nx projects`,
]

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
