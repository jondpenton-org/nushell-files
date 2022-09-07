export def "nu-complete rush autoinstallers" [] {
  git-root
    | path join common/autoinstallers
    | ls $in
    | get name
    | path basename
}

export def "nu-complete rush projects" [] {
  git-root
    | path join rush.json
    | if not ($in | path exists) {
        []
      } else {
        open $in | get projects.packageName
      }
}
