export def "nu-complete nx output-style" [] {
  [`compact`, `dynamic`, `static`, `stream`, `stream-without-prefixes`] | sort
}

export def "nu-complete nx project targets" [] {
  git-root
    | path join workspace.json
    | open $in
    | $in.projects
    | transpose project path
    | par-each { |row|
        $row.path
          | path join project.json
          | open $in
          | $in.targets
          | transpose key
          | $in.key
          | par-each { |target| $"($row.project):($target)" }
      }
    | sort
}

export def "nu-complete nx projects" [] {
  git-root
    | path join workspace.json
    | open $in
    | $in.projects
    | transpose project
    | $in.project
    | sort
}
