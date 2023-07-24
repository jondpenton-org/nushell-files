use modules/git git-root

export def "nu-complete pnpm log level" [] {
  [`debug`, `info`, `warn`, `error`]
}

export def "nu-complete pnpm projects" [] {
  do { cd (git-root); open pnpm-workspace.yaml }
    | $in.packages
    | par-each { path join package.json | glob --depth 3 $in }
    | flatten
    | par-each { |it|
        { value: (open $it | $in.name), description: ($it | path dirname) }
      }
    | sort-by value
}

export def "nu-complete pnpm severity" [] {
  [`major`, `minor`, `patch`]
}
