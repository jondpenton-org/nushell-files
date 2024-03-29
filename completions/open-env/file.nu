# Requires: `open-env`
export def 'nu-complete open-env file' []: any -> list<string> {
  let git_root = ^git-root
  let envs_relative_to_git_root = (
    do { cd $git_root; glob --depth 3 **/*.env }
      | where not ($it =~ example or (open-env $it | is-empty))
      | path relative-to $git_root
  )
  let pwd_relative_to_git_root = $env.PWD | path relative-to $git_root

  $envs_relative_to_git_root | each { |it|
    if $it starts-with $pwd_relative_to_git_root {
      let dirs_diff_length = $pwd_relative_to_git_root | path split | length

      $it
        | path split
        | range ($dirs_diff_length)..
        | path join
    } else {
      let git_root_relative_to_pwd = (
        $pwd_relative_to_git_root
          | path split
          | each { '..' }
          | path join
      )

      [$git_root_relative_to_pwd, $it] | path join
    }
  }
}
