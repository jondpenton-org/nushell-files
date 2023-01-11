use ../helpers.nu build-flags
use yarn.completion.nu [
  `nu-complete yarn outdated severity`,
  `nu-complete yarn outdated type`,
]

# View outdated dependencies
export def yarn-outdated [
  --print-latest (-l)                                             # Prints outdated dependencies as `<package>@^<wantedVersion>`
  --severity (-s): string@"nu-complete yarn outdated severity"    # Filter results based on the severity of the update
  --type (-t): string@"nu-complete yarn outdated type"            # Filter results based on the dependency type
] {
  let flags = build-flags {
    severity: $severity,
    type: $type,
  }
  let table = (
    yarn outdated $flags
      | lines
      | skip 4
      | drop 3
      | parse -r '➤ YN0000: (?P<package>\S+)\s+(?P<currentVersion>(?:\d+\.?)+)\s+(?P<latestVersion>(?:\d+\.?)+)\s+\w*[dD]ependencies'
  )

  if $print_latest {
    $table | par-each { |it|
        $'($it.package)@^($it.latestVersion)'
          | if ($in | str contains ^0) {
              $in | str replace \^0 ~0
            } else {
              $in
            }
      }
  } else {
    $table
  }
}
