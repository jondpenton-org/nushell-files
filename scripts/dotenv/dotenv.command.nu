use ../git.nu git-root
use ../helpers.nu table-into-record

# Converts .env file into record
export def open-env [
  file: path@"nu-complete open-env file"   # .env file
] {
  open $file
    | lines
    | where ($it !~ `^\w+=".*\$[A-Z].*"`) # Exclude lines like `PATH="<path>:$PATH"`
    | str replace --all `^(\w+)=([^'"]+)` `${1}='${2}'` # `PORT=3000` to `PORT='3000'`
    | str replace --all `^(\w+)="(.*)"` `${1}='${2}'` # `PORT="3000"` to `PORT='3000'`
    | each { || parse --regex `^(?P<key>\w+)='(?P<value>.*)'` }
    | flatten
    | table-into-record
}

# Converts .envrc file into record
export def open-envrc [
  file: path@"nu-complete open-envrc file"   # .envrc file
] {
  open $file
    | lines
    | str replace --all --string `"` `'`
    | str replace --all `=([\w\d]+)` `='${1}'`
    | reduce --fold {} { |it, acc|
        let variables = (
          if $it starts-with export {
            $it
              | parse --regex `^export\s+(?P<key>[\w_]+)='(?P<value>.*)'`
              | table-into-record
          } else if $it starts-with source_env {
            $it
              | parse --regex `^source_env(?:_if_exists)?\s+(?P<name>.*)`
              | $in.name.0
              | path expand
              | open-envrc $in
          } else if $it starts-with dotenv {
            $file
              | path dirname
              | path join (
                  $it
                    | parse `dotenv {name}`
                    | $in.name.0
                )
              | path expand
              | open-env $in
          }
        )

        if ($variables | is-empty) {
          $acc
        } else {
          $acc | merge $variables
        }
      }
}

# Like `with-env`, but pass .env file instead of environment variable set
export def with-dot-env [
  file: path@"nu-complete open-env file"    # .env file
  block: closure                              # Block ran with variables in passed file
] {
  with-env (open-env $file) $block
}

# Like `with-env`, but pass .envrc file instead of environment variable set.
export def with-envrc [
  file: path@"nu-complete open-envrc file"   # .envrc file
  block: closure                               # Block ran with variables in passed file
] {
  with-env (open-envrc $file) $block
}

## Completions

def "nu-complete open-env file" [] {
  let git_root = (git-root)
  let envs_relative_to_git_root = (
    do { || cd $git_root; glob --depth 3 **/*.env }
      | where not ($it =~ example or (open-env $it | is-empty))
      | path relative-to $git_root
  )
  let pwd_relative_to_git_root = (
    $env.PWD | path relative-to $git_root
  )

  $envs_relative_to_git_root | par-each { |it|
    if $it starts-with $pwd_relative_to_git_root {
      let dirs_diff_length = (
        $pwd_relative_to_git_root | path split | length
      )

      $it
        | path split
        | range ($dirs_diff_length)..
        | path join
    } else {
      let git_root_relative_to_pwd = (
        $pwd_relative_to_git_root
          | path split
          | par-each { || '..' }
          | path join
      )

      [$git_root_relative_to_pwd, $it] | path join
    }
  }
}

def "nu-complete open-envrc file" [] {
  let git_root = (git-root)
  let envrcs_relative_to_git_root = (
    do { || cd $git_root; glob --depth 3 **/*.envrc }
      | where not ($it =~ example or (open-envrc $it | is-empty))
      | path relative-to $git_root
  )
  let pwd_relative_to_git_root = (
    $env.PWD | path relative-to $git_root
  )

  $envrcs_relative_to_git_root | par-each { |it|
    if $it starts-with $pwd_relative_to_git_root {
      let dirs_diff_length = (
        $pwd_relative_to_git_root | path split | length
      )

      $it
        | path split
        | range ($dirs_diff_length)..
        | path join
    } else {
      let git_root_relative_to_pwd = (
        $pwd_relative_to_git_root
          | path split
          | par-each { || '..' }
          | path join
      )

      [$git_root_relative_to_pwd, $it] | path join
    }
  }
}
