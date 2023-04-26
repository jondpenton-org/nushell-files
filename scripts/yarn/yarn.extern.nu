use yarn.completion.nu [
  `nu-complete yarn outdated severity`,
  `nu-complete yarn outdated type`,
]

# TODO: Remove
def "nu-complete yarn outdated severity" [] {
  [`major`, `minor`, `patch`]
}

# TODO: Remove
def "nu-complete yarn outdated type" [] {
  [`dependencies`, `devDependencies`]
}

export extern "yarn outdated" [
  --all (-a) # Include outdated dependencies from all workspaces
  --check (-c) # Exit with exit code 1 when outdated dependencies are found
  --json # Format the output as JSON
  --severity (-s): string@'nu-complete yarn outdated severity' # Filter results based on the severity of the update
  --type (-t): string@'nu-complete yarn outdated type' # Filter results based on the dependency type
  --url # Include the homepage URL of each package in the output
]
