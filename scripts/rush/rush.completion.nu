export def "nu-complete rush autoinstallers" [] {
  ls (git-root | path join `common/autoinstallers`)
    | get name
    | path basename
}

export def "nu-complete rush projects" [] {
  let config_path = (
    git-root | path join rush.json
  )

  if not ($config_path | path exists) {
    return []
  }

  open $in | get projects.packageName
}
