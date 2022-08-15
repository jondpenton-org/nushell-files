## Commands

# Parse text as .envrc and create record
export def from-envrc [] {
  $in
    | lines
    | reduce --fold {} { |it, acc|
        $acc | merge {
          if ($it | str starts-with 'export ') {
            $it
              | parse --regex "export (?P<key>[\\w_]+)='?(?P<value>[^']+)"
              | table-into-record
          } else if ($it | str starts-with 'source_env') {
            $it
              | parse --regex "source_env(?:_if_exists)? (?P<name>.*)"
              | get -i name.0
              | if ($in | empty?) {
                  {}
                } else {
                  open-envrc $in
                }
          } else if ($it | str starts-with 'dotenv ') {
            $it
              | parse "dotenv {name}"
              | get name.0
              | open-env $in
          } else {
            {}
          }
        }
      }
    | uniq-record
}

# Converts .env file into record
export def open-env [
  file: path@"nu-complete open-env file"   # .env file
] {
  $file
    | path expand
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
    | path expand
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
  let git-root = git-root
  let envs-relative-to-git-root = (
    do { cd $git-root; glob --depth 3 **/*.env }
      | where not ($it =~ example || (open-env $it | empty?))
      | path relative-to $git-root
  )
  let pwd-relative-to-git-root = (
    if $git-root == $env.PWD {
      ''
    } else {
      $env.PWD | path relative-to $git-root
    }
  )

  $envs-relative-to-git-root | par-each { |it|
    if ($it | str starts-with $pwd-relative-to-git-root) {
      let dirs-diff-length = (
        $pwd-relative-to-git-root | path split | length
      )

      $it
        | path split
        | range ($dirs-diff-length)..
        | path join
    } else {
      let git-root-relative-to-pwd = (
        $pwd-relative-to-git-root
          | path split
          | par-each { '..' }
          | path join
      )

      [$git-root-relative-to-pwd, $it] | path join
    }
  }
}

def "nu-complete open-envrc file" [] {
  let git-root = git-root
  let envrcs-relative-to-git-root = (
    do { cd $git-root; glob --depth 3 **/*.envrc }
      | where not ($it =~ example || (open-envrc $it | empty?))
      | path relative-to $git-root
  )
  let pwd-relative-to-git-root = (
    if $git-root == $env.PWD {
      ''
    } else {
      $env.PWD | path relative-to $git-root
    }
  )

  $envrcs-relative-to-git-root | par-each { |it|
    if ($it | str starts-with $pwd-relative-to-git-root) {
      let dirs-diff-length = (
        $pwd-relative-to-git-root | path split | length
      )

      $it
        | path split
        | range ($dirs-diff-length)..
        | path join
    } else {
      let git-root-relative-to-pwd = (
        $pwd-relative-to-git-root
          | path split
          | each { '..' }
          | path join
      )

      [$git-root-relative-to-pwd, $it] | path join
    }
  }
}
