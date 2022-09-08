export def "nu-complete git branches" [] {
  git branch
    | lines
    | par-each { |line|
        $line | str replace '[\*\+] ' '' | str trim
      }
}

export def "nu-complete git remotes" [] {
  git remote
    | lines
    | par-each { |line|
        $line | str trim
      }
}
