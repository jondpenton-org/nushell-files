export def "nu-complete ssh destination" [] {
  open `~/.ssh/config`
    | lines
    | where $it starts-with `Host `
    | each { parse `Host {destination}` }
    | flatten
    | $in.destination?
    | where not ($it | is-empty)
    | default []
}
