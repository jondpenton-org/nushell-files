use modules/helpers build-flags
use yarn.completion.nu [
  `nu-complete yarn outdated severity`,
  `nu-complete yarn outdated type`,
]

# View outdated dependencies
export def yarn-outdated [
  --print-latest (-l) # Prints outdated dependencies as `<package>@^<wantedVersion>`
  --severity (-s): string@'nu-complete yarn outdated severity' # Filter results based on the severity of the update
  --type (-t): string@'nu-complete yarn outdated type' # Filter results based on the dependency type
] {
  let flags = (
    build-flags {
      json: true,
      severity: $severity,
      type: $type,
    }
  )

  ^yarn outdated $flags
    | from json
    | when { $print_latest } { each { $"($in.name)@^($in.latest)" } }
}
