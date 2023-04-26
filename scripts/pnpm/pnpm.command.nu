use ../helpers.nu build-flags
use pnpm.completion.nu [
  `nu-complete pnpm log level`,
  `nu-complete pnpm projects`,
  `nu-complete pnpm severity`,
]

# Check for outdated packages. The check can be limited to a subset of the installed packages by providing arguments (patterns are supported).
export def pnpm-outdated [
  --aggregate-output # Aggregate output from child processes that are run in parallel, and only print output when child process is finished. It makes reading large logs after running `pnpm recursive` with `--parallel` or with `--workspace-concurrency` much easier (especially on CI). Only `--reporter=append-only` is supported.
  --color # Controls colors in the output. By default, output is always colored when it goes directly to a terminal
  --compatible # Print only versions that satisfy specs in package.json
  --dev (-D) # Check only "devDependencies"
  --dir (-C): path # Change to directory <dir> (default: /workspace/cpu-servers)
  --filter: string@'nu-complete pnpm projects'
  --global-dir: path # Specify a custom directory to store global packages
  --help (-h) # Output usage information
  --list (-l) # Returns list of package version selectors to pass to `pnpm add`
  --loglevel: string@'nu-complete pnpm log level' # What level of logs to report. Any logs at or higher than the given level will be shown. Or use "--silent" to turn off all logging.
  --long # By default, details about the outdated packages (such as a link to the repo) are not displayed. To display
  --no-color # Controls colors in the output. By default, output is always colored when it goes directly to a terminal the details, pass this option.
  --no-optional # Don't check "optionalDependencies"
  --no-table # Prints the outdated packages in a list. Good for small consoles
  --prod (-P) # Check only "dependencies" and "optionalDependencies"
  --recursive (-r) # Check for outdated dependencies in every package found in subdirectories or in every workspace package, when executed inside a workspace. For options that may be used with `-r`, see "pnpm help recursive"
  --severity (-s): string@'nu-complete pnpm severity'
  --stream # Stream output from child processes immediately, prefixed with the originating package directory. This allows output from different packages to be interleaved.
  --use-stderr # Divert all output to stderr
  --workspace-root (-w) # Run the command on the root workspace project
] {
  let flags = (
    build-flags {
      aggregate-output: $aggregate_output
      color: $color
      compatible: $compatible
      dev: $dev
      dir: $dir
      filter: $filter
      global-dir: $global_dir
      help: $help
      loglevel: $loglevel
      long: $long
      no-color: $no_color
      no-optional: $no_optional
      no-table: $no_table
      prod: $prod
      recursive: $recursive
      stream: $stream
      use-stderr: $use_stderr
      workspace-root: $workspace_root
    }
  )
  let outdated_table = (
    ^pnpm outdated $flags
      | lines
      | skip 1
      | drop 1
      | str trim --char `│`
      | split list ($in | where $it starts-with `├─` | $in.0)
      | each { |it, index|
          match $index {
            0 => ($it.0 | str downcase),
            _ => (
              $it
                | str replace `^(\s+│)+\s+` ``
                | str trim
                | str join
            )
          }
        }
      | split column `│`
      | str trim
      | headers
      | each {
          when { $in =~ dependents } {
            update dependents { $in.dependents | split row , }
          }
            | insert dev { $in.package | str ends-with ` (dev)` }
            | update package {
                $in.package | str replace --string ` (dev)` ``
              }
        }
      | move dev --after package
      | when { not ($severity | is-empty) } {
          let input = $in
          let check_parts = (
            (nu-complete pnpm severity)
              | each { |it, index|
                  if $it == $severity {
                    $index
                  }
                }
              | $in.0
          )

          $input
            | filter { |it|
                let current_parts = ($it.current | split row .)
                let latest_parts = ($it.latest | split row .)
                let check_parts = (
                  $check_parts
                    | when { $current_parts.0 == `0` } {
                        $in + 1
                      }
                    | when { $in > 2 } 2
                )
                let assertions = (
                  match $check_parts {
                    0 => [
                      ($current_parts.0 != $latest_parts.0)
                    ],
                    1 => [
                      ($current_parts.0 == $latest_parts.0),
                      ($current_parts.1 != $latest_parts.1),
                    ],
                    2 => [
                      ($current_parts.0 == $latest_parts.0),
                      ($current_parts.1 == $latest_parts.1),
                    ]
                  }
                )

                $assertions
                  | where not $it
                  | is-empty
              }
        }
  )

  if not $list {
    return $outdated_table
  }

  $outdated_table
    | each { $'($in.package)@^($in.latest)' }
    | uniq
    | default []
    | sort
}
