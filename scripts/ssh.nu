## Externs

export extern "ssh" [
  destination: string@"nu-complete ssh destination"
]

## Completions

def "nu-complete ssh destination" [] {
  open ~/.ssh/config
    | lines
    | where $it starts-with `Host `
    | parse `Host {destination}`
    | get --ignore-errors destination
    | default []
}
