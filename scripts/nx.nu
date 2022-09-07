## Aliases

export alias pnx = pnpm exec nx

## Externs

# Run a target for a project
export extern "pnpm exec nx run" [
  target: string@"nu-complete nx project targets"

  --configuration (-c): string                            # Target configuration
  --help                                                  # Show help
  --nx-bail                                               # Stop command execution after the first failed task
  --nx-ignore-cycles                                      # Ignore cycles in the task graph
  --output-style: string@"nu-complete nx output-style"    # Defines how Nx emits outputs tasks logs
  --prod                                                  # Use the production configuration
  --project: string@"nu-complete nx projects"             # Target project
  --skip-nx-cache                                         # Don't use cache
  --version                                               # Show version number
]

## Completions

def "nu-complete nx output-style" [] {
  [dynamic, static, stream, stream-without-prefixes, compact] | sort
}

def "nu-complete nx projects" [] {
  git-root
    | path join workspace.json
    | open $in
    | get projects
    | transpose project
    | get project
    | sort
}

def "nu-complete nx project targets" [] {
  git-root
    | path join workspace.json
    | open $in
    | get projects
    | transpose project path
    | par-each { |row|
        $row.path
          | path join project.json
          | open $in
          | get targets
          | transpose key
          | get key
          | par-each { |target| $'($row.project):($target)' }
      }
    | sort
}
