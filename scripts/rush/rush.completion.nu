export def "nu-complete rush autoinstallers" [] {
  ls (git-root | path join `common/autoinstallers`)
    | $in.name
    | path basename
}

export def "nu-complete rush projects" [] {
  let config_path = git-root | path join rush.json

  if not ($config_path | path exists) {
    return []
  }

  open $config_path | $in.projects.packageName
}
