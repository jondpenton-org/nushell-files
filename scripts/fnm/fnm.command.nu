export def fnm-alias-bin-path [
  alias: string@"nu-complete fnm aliases"
] {
  let aliases_dir = (
    fnm-dir | path join aliases
  )
  let alias_dir = (
    ls $aliases_dir
      | where name ends-with $alias
      | get --ignore-errors name.0
  )

  if ($alias_dir | is-empty) {
    return
  }

  $alias_dir | path join bin
}

export def fnm-dir [] {
  fnm env --shell bash
    | lines
    | where (`FNM_DIR` in $it)
    | parse `export FNM_DIR="{path}"`
    | get path.0
}

export def node-versions-dir [] {
  fnm-dir | path join node-versions
}

# Execute block with Node version
export def with-node [
  version: string@"nu-complete with-node versions",
  block: closure
] {
  let node_path = (
    node-versions-dir
      | path join $version
      | path join installation/bin
  )
  let new_path = (
    $env
      | get PATH
      | prepend $node_path
      | do ($env | get ENV_CONVERSIONS.PATH.to_string) $in
  )
  let env_record = {
    PATH: $new_path
  }

  with-env $env_record $block
}

## Completions

def "nu-complete fnm aliases" [] {
  fnm-dir
    | path join aliases
    | ls $in
    | get name
    | path basename
    | sort
}

def "nu-complete with-node versions" [] {
  ls (node-versions-dir) | get name | path basename
}
