## Commands

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
  fnm-dir | path join aliases/default/bin
)

## Completions

def "nu-complete with-node versions" [] {
  ls (node-versions-dir) | get name | path basename
}
