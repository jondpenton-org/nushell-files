# Requires: `open-envrc`
export def 'nu-complete open-envrc file' []: any -> list<string> {
  let git_root = ^git-root
  let envrcs_relative_to_git_root = (
    do { cd $git_root; glob --depth 3 **/*.envrc }
      | where not ($it =~ 'example' or (open-envrc $it | is-empty))
      | path relative-to $git_root
  )
  let pwd_relative_to_git_root = $env.PWD | path relative-to $git_root

  $envrcs_relative_to_git_root | each { |it|
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
