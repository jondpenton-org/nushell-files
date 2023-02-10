use nx.completion.nu [
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
