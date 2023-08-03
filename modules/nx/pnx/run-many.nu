use completions/nx/all/targets.nu *

# Run target for multiple listed projects
export extern main [
  --target (-t): string@'nu-complete nx all targets' # Tasks to run for affected projects
]
