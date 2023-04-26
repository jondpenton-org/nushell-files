use ssh.completions.nu `nu-complete ssh destination`

# TODO: Remove
def "nu-complete ssh destination" [] {
  open `~/.ssh/config`
    | lines
    | where $it starts-with `Host `
    | each { parse `Host {destination}` }
    | flatten
    | $in.destination?
    | where not ($it | is-empty)
    | default []
}

extern ssh [
  destination: string@'nu-complete ssh destination'
]
