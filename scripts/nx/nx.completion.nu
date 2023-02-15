export def "nu-complete nx output-style" [] {
  [`compact`, `dynamic`, `static`, `stream`, `stream-without-prefixes`] | sort
}

export def "nu-complete nx project targets" [] {
  git-root
    | path join workspace.json
    | open $in
    | get projects
    | transpose project path
    | par-each { |it|
        get path
          | path join project.json
          | open $in
          | get targets
          | transpose key
          | get key
          | par-each { |target| $"($it | get project):($target)" }
      }
    | sort
}

export def "nu-complete nx projects" [] {
  git-root
    | path join workspace.json
    | open $in
    | get projects
    | transpose project
    | get project
    | sort
}
