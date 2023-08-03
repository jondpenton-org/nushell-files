use completions/nx/all/targets.nu *
use completions/nx/output-style.nu *
use completions/nx/projects.nu *

# Run target for affected projects
export extern main [
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
