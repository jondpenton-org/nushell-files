## Commands

export def fnm-alias-bin-path [
  alias: string
] {
  let aliases-dir = (
    fnm-dir | path join aliases
  )
  let alias-dir = (
    $aliases-dir
      | ls $in
      | where name ends-with $alias
      | get --ignore-errors name.0
  )

  if not ($alias-dir | empty?) {
    $alias-dir | path join bin
  }
}

export def fnm-dir [] {
  fnm env --shell bash
    | lines
    | where ($it | str contains FNM_DIR)
    | parse 'export FNM_DIR="{path}"'
    | get path.0
}

export def node-versions-dir [] {
  fnm-dir | path join node-versions
}

# Execute block with Node version
export def with-node [
  version: string@"nu-complete with-node versions",
  block: block
] {
  let node-path = (
    node-versions-dir
      | path expand
      | path join $version
      | path join 'installation/bin'
  )
  let new-path = (
    $env.PATH
      | prepend $node-path
      | do $env.ENV_CONVERSIONS.PATH.to_string $in
  )
  let env-record = {
    PATH: $new-path
  }

  with-env $env-record $block
}

## Aliases

export alias fnm-default-bin-path = (
  fnm-alias-bin-path nushell
    | if ($in | empty?) {
        fnm-alias-bin-path default
      } else {
        $in
      }
)

## Completions

def "nu-complete with-node versions" [] {
  ls (node-versions-dir) | get name | path basename
}
