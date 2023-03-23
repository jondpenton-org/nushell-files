## Externs

export extern main [
  destination: string@"nu-complete ssh destination"
]

## Completions

def "nu-complete ssh destination" [] {
  open `~/.ssh/config`
    | lines
    | where $it starts-with `Host `
    | each { parse `Host {destination}` }
    | flatten
    | get --ignore-errors destination
    | where not ($it | is-empty)
    | default []
}
