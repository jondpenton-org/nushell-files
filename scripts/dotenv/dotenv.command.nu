use ../git.nu git-root
use ../helpers.nu table-into-record

# Parse text as .envrc and create record
export def from-envrc [] {
  $in
    | lines
    | str replace --all --string `"` `'`
    | str replace --all `=(\w\S+)` `='${1}'`
    | reduce --fold {} { |it, acc|
        $acc 
          | merge {
              if $it starts-with `export ` {
                $it
                  | parse --regex `^export\s+(?P<key>[\w_]+)='(?P<value>.*)'`
                  | table-into-record
              } else if $it starts-with `source_env` {
                $it
                  | parse --regex `^source_env(?:_if_exists)?\s+(?P<name>.*)`
                  | get --ignore-errors name.0
                  | if ($in | is-empty) {
                      {}
                    } else {
                      open-envrc $in
                    }
              } else if $it starts-with `dotenv ` {
                $it
                  | parse `dotenv {name}`
                  | open-env $in.name.0
              } else {
                {}
              }
            }
      }
}

# Converts .env file into record
export def open-env [
  file: path@"nu-complete open-env file"   # .env file
] {
  $file
    | open $in
    | lines
    | parse --regex "^(?P<key>[\\w_]+)='(?P<value>.*)'"
    | table-into-record
}

# Converts .envrc file into record
export def open-envrc [
  file: path@"nu-complete open-envrc file"   # .envrc file
] {
  $file
    | open $in
    | from-envrc
}

# Like `with-env`, but pass .env file instead of environment variable set
export def with-dot-env [
  file: path@"nu-complete open-env file"    # .env file
  block: block                              # Block ran with variables in passed file
] {
  with-env (open-env $file) $block
}

# Like `with-env`, but pass .envrc file instead of environment variable set.
export def with-envrc [
  file: path@"nu-complete open-envrc file"   # .envrc file
  block: block                               # Block ran with variables in passed file
] {
  with-env (open-envrc $file) $block
}

## Completions

def "nu-complete open-env file" [] {
  let git_root = git-root
  let envs_relative_to_git_root = (
    do { cd $git_root; glob --depth 3 **/*.env }
      | where not ($it =~ example || (open-env $it | is-empty))
      | path relative-to $git_root
  )
  let pwd_relative_to_git_root = (
    if $git_root == $env.PWD {
      ''
    } else {
      $env.PWD | path relative-to $git_root
    }
  )

  $envs_relative_to_git_root | par-each { |it|
    if ($it | str starts-with $pwd_relative_to_git_root) {
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
          | par-each { '..' }
          | path join
      )

      [$git_root_relative_to_pwd, $it] | path join
    }
  }
}

def "nu-complete open-envrc file" [] {
  let git_root = git-root
  let envrcs_relative_to_git_root = (
    do { cd $git_root; glob --depth 3 **/*.envrc }
      | where not ($it =~ example || (open-envrc $it | is-empty))
      | path relative-to $git_root
  )
  let pwd_relative_to_git_root = (
    if $git_root == $env.PWD {
      ''
    } else {
      $env.PWD | path relative-to $git_root
    }
  )

  $envrcs_relative_to_git_root | par-each { |it|
    if ($it | str starts-with $pwd_relative_to_git_root) {
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
          | each { '..' }
          | path join
      )

      [$git_root_relative_to_pwd, $it] | path join
    }
  }
}