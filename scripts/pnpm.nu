use git.nu git-root
use helpers.nu build-flags

## Commands

# Check for outdated packages. The check can be limited to a subset of the installed packages by providing arguments (patterns are supported).
export def pnpm-outdated [
  --aggregate-output                                              # Aggregate output from child processes that are run in parallel, and only print output when child process is finished. It makes reading large logs after running `pnpm recursive` with `--parallel` or with `--workspace-concurrency` much easier (especially on CI). Only `--reporter=append-only` is supported.
  --color                                                         # Controls colors in the output. By default, output is always colored when it goes directly to a terminal
  --compatible                                                    # Print only versions that satisfy specs in package.json
  --dev (-D)                                                      # Check only "devDependencies"
  --dir (-C): path                                                # Change to directory <dir> (default: /workspace/cpu-servers)
  --filter: string@"nu-complete pnpm projects"
  --global-dir: path                                              # Specify a custom directory to store global packages
  --help (-h)                                                     # Output usage information
  --list (-l)                                                     # Returns list of package version selectors to pass to `pnpm add`
  --loglevel: string@"nu-complete pnpm log level"                 # What level of logs to report. Any logs at or higher than the given level will be shown. Or use "--silent" to turn off all logging.
  --long                                                          # By default, details about the outdated packages (such as a link to the repo) are not displayed. To display
  --no-color                                                      # Controls colors in the output. By default, output is always colored when it goes directly to a terminal the details, pass this option.
  --no-optional                                                   # Don't check "optionalDependencies"
  --no-table                                                      # Prints the outdated packages in a list. Good for small consoles
  --prod (-P)                                                     # Check only "dependencies" and "optionalDependencies"
  --recursive (-r)                                                # Check for outdated dependencies in every package found in subdirectories or in every workspace package, when executed inside a workspace. For options that may be used with `-r`, see "pnpm help recursive"
  --severity (-s): string@"nu-complete pnpm severity"
  --stream                                                        # Stream output from child processes immediately, prefixed with the originating package directory. This allows output from different packages to be interleaved.
  --use-stderr                                                    # Divert all output to stderr
  --workspace-root (-w)                                           # Run the command on the root workspace project
] {
  let flags = build-flags {
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
  let outdated_table = (
    ^pnpm outdated $flags
      | lines
      | skip 1
      | drop 1
      | str trim --char `│`
      | split list ($in | where $it starts-with `├─` | $in.0)
      | each --numbered { |it|
          if $it.index == 0 {
            $it.item.0 | str downcase
          } else {
            $it.item
              | str replace `^(\s+│)+\s+` ``
              | str trim
              | str collect
          }
        }
      | split column `│`
      | str trim
      | headers
      | par-each { |row|
          $row
            | if `dependents` in $row {
                update `dependents` ($row.dependents | split row `,`)
              } else {
                $in
              }
            | insert `dev` ($row.package ends-with ` (dev)`)
            | update `package` ($row.package | str replace --string ` (dev)` ``)
        }
      | move `dev` --after `package`
      | if ($severity | is-empty) {
          $in
        } else {
          let old_in = $in
          let check_parts = (
            (nu-complete pnpm severity)
              | par-each --numbered { |it|
                  if $it.item == $severity {
                    $it.index
                  }
                }
              | $in.0
          )

          $old_in
            | where --block { |row|
                let current_parts = ($row.current | split row `.`)
                let latest_parts = ($row.latest | split row `.`)
                let check_parts = (
                  $check_parts
                    | if $current_parts.0 != `0` {
                        $in
                      } else {
                        $in + 1
                      }
                    | if $in <= 2 {
                        $in
                      } else {
                        2
                      }
                )
                let assertions = (
                  if $check_parts == 0 {
                    [($current_parts.0 != $latest_parts.0)]
                  } else if $check_parts == 1 {
                    [
                      ($current_parts.0 == $latest_parts.0),
                      ($current_parts.1 != $latest_parts.1),
                    ]
                  } else if $check_parts == 2 {
                    [
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
    $outdated_table
  } else {
    $outdated_table
      | par-each { |it|
          let range = (
            if $it.package starts-with `@types/` {
              $nothing
            } else if $it.latest starts-with `0` {
              `~`
            } else {
              `^`
            }
          )

          $'($it.package)@($range)($it.latest)'
        }
      | if not ($in | is-empty) {
          uniq | sort
        }
  }
}

## Externs

export extern pnpm [
  --filter: string@"nu-complete pnpm projects"
  --help (-h)
  --recursive (-r)                                # Run the command for each project in the workspace.
  --version (-v)

  ...args
]

# Installs a package and any packages that it depends on.
export extern "pnpm add" [
  --aggregate-output                                # Aggregate output from child processes that are run in parallel, and only print output when child process is finished. It makes reading large logs after running `pnpm recursive` with `--parallel` or with `--workspace-concurrency` much easier (especially on CI). Only `--reporter=append-only` is supported.
  --color                                           # Controls colors in the output. By default, output is always colored when it goes directly to a
  --dir (-C): path                                  # Change to directory <dir> (default: /workspace/cpu-servers)
  --filter: string@"nu-complete pnpm projects"
  --global (-g)                                     # Install as a global package
  --global-dir: path                                # Specify a custom directory to store global packages
  --help (-h)                                       # Output usage information
  --ignore-scripts                                  # Don't run lifecycle scripts
  --loglevel: string@"nu-complete pnpm log level"   # What level of logs to report. Any logs at or higher than the given level will be shown. Or use "--silent" to turn off all logging.
  --no-color                                        # Controls colors in the output. By default, output is always colored when it goes directly to a
  --no-save-exact                                   # Install exact version
  --no-save-workspace-protocol                      # Save packages from the workspace with a "workspace:" protocol. True by default
  --offline                                         # Trigger an error if any required dependencies are not available in local store
  --prefer-offline                                  # Skip staleness checks for cached data, but request missing data from the server
  --recursive (-r)                                  # Run installation recursively in every package found in subdirectories or in every workspace package, when executed inside a workspace. For options that may be used with `-r`, see "pnpm help recursive"
  --save-dev (-D)                                   # Save package to your `devDependencies`
  --save-exact (-E)                                 # Install exact version
  --save-optional (-O)                              # Save package to your `optionalDependencies`
  --save-peer                                       # Save package to your `peerDependencies` and `devDependencies`
  --save-prod (-P)                                  # Save package to your `dependencies`. The default behavior
  --save-workspace-protocol                         # Save packages from the workspace with a "workspace:" protocol. True by default
  --store-dir: path                                 # The directory in which all the packages are saved on the disk
  --stream                                          # Stream output from child processes immediately, prefixed with the originating package directory. This allows output from different packages to be interleaved.
  --use-stderr                                      # Divert all output to stderr
  --virtual-store-dir: path                         # The directory with links to the store (default is node_modules/.pnpm). All direct and indirect dependencies of the project are linked into this directory
  --workspace                                       # Only adds the new dependency if it is found in the workspace
  --workspace-root (-w)                             # Run the command on the root workspace project terminal

  ...args: string
]

# Check for outdated packages. The check can be limited to a subset of the installed packages by providing arguments (patterns are supported).
export extern "pnpm outdated" [
  --aggregate-output                                # Aggregate output from child processes that are run in parallel, and only print output when child process is finished. It makes reading large logs after running `pnpm recursive` with `--parallel` or with `--workspace-concurrency` much easier (especially on CI). Only `--reporter=append-only` is supported.
  --color                                           # Controls colors in the output. By default, output is always colored when it goes directly to a terminal
  --compatible                                      # Print only versions that satisfy specs in package.json
  --dev (-D)                                        # Check only "devDependencies"
  --dir (-C): path                                  # Change to directory <dir> (default: /workspace/cpu-servers)
  --filter: string@"nu-complete pnpm projects"
  --global-dir: path                                # Specify a custom directory to store global packages
  --help (-h)                                       # Output usage information
  --loglevel: string@"nu-complete pnpm log level"   # What level of logs to report. Any logs at or higher than the given level will be shown. Or use "--silent" to turn off all logging.
  --long                                            # By default, details about the outdated packages (such as a link to the repo) are not displayed. To display
  --no-color                                        # Controls colors in the output. By default, output is always colored when it goes directly to a terminal the details, pass this option.
  --no-optional                                     # Don't check "optionalDependencies"
  --no-table                                        # Prints the outdated packages in a list. Good for small consoles
  --prod (-P)                                       # Check only "dependencies" and "optionalDependencies"
  --recursive (-r)                                  # Check for outdated dependencies in every package found in subdirectories or in every workspace package, when executed inside a workspace. For options that may be used with `-r`, see "pnpm help recursive"
  --stream                                          # Stream output from child processes immediately, prefixed with the originating package directory. This allows output from different packages to be interleaved.
  --use-stderr                                      # Divert all output to stderr
  --workspace-root (-w)                             # Run the command on the root workspace project
]

# Shows the packages that depend on <pkg>
export extern "pnpm why" [
  --aggregate-output                                # Aggregate output from child processes that are run in parallel, and only print output when child process is finished. It makes reading large logs after running `pnpm recursive` with `--parallel` or with `--workspace-concurrency` much easier (especially on CI). Only `--reporter=append-only` is supported.
  --color                                           # Controls colors in the output. By default, output is always colored when it goes directly to a terminal
  --dev (-D)                                        # Check only "devDependencies"
  --dir (-C): path                                  # Change to directory <dir> (default: /workspace/cpu-servers)
  --filter: string@"nu-complete pnpm projects"
  --global (-g)                                     # List packages in the global install prefix instead of in the current project
  --global-dir: path                                # Specify a custom directory to store global packages
  --help (-h)                                       # Output usage information
  --json                                            # Show information in JSON format
  --loglevel: string@"nu-complete pnpm log level"   # What level of logs to report. Any logs at or higher than the given level will be shown. Or use "--silent" to turn off all logging.
  --long                                            # By default, details about the outdated packages (such as a link to the repo) are not displayed. To display
  --no-color                                        # Controls colors in the output. By default, output is always colored when it goes directly to a terminal the details, pass this option.
  --no-optional                                     # Don't check "optionalDependencies"
  --parseable                                       # Show parseable output instead of tree view
  --prod (-P)                                       # Check only "dependencies" and "optionalDependencies"
  --recursive (-r)                                  # Check for outdated dependencies in every package found in subdirectories or in every workspace package, when executed inside a workspace. For options that may be used with `-r`, see "pnpm help recursive"
  --stream                                          # Stream output from child processes immediately, prefixed with the originating package directory. This allows output from different packages to be interleaved.
  --use-stderr                                      # Divert all output to stderr
  --workspace-root (-w)                             # Run the command on the root workspace project

  pkg: string
]

## Completions

def "nu-complete pnpm log level" [] {
  [debug, info, warn, error]
}

def "nu-complete pnpm projects" [] {
  do { cd (git-root); open pnpm-workspace.yaml }
    | get packages
    | each { |it| glob --depth 3 $'($it)/package.json' }
    | flatten
    | each { |it| open $it | get name }
}

def "nu-complete pnpm severity" [] {
  [major, minor, patch]
}
