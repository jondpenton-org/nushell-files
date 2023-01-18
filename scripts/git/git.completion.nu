export def "nu-complete git branches" [] {
  git branch
    | lines
    | par-each { |it|
        $it | str replace `[*+] ` `` | str trim
      }
}

export def "nu-complete git remotes" [] {
  git remote
    | lines
    | par-each { |it|
        $it | str trim
      }
}
