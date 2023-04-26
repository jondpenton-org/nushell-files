export def "nu-complete git branches" [] {
  ^git branch
    | lines
    | str replace ^\* ``
    | str trim
}

export def "nu-complete git remotes" [] {
  ^git remote
    | lines
    | str trim
}
