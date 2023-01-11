use ../git.nu git-root

export def "nu-complete pnpm log level" [] {
  [debug, info, warn, error]
}

export def "nu-complete pnpm projects" [] {
  do { cd (git-root); open pnpm-workspace.yaml }
    | $in.packages
    | par-each { |it| glob --depth 3 $'($it)/package.json' }
    | flatten
    | par-each { |it| open $it | $in.name }
    | sort
}

export def "nu-complete pnpm severity" [] {
  [major, minor, patch]
}
