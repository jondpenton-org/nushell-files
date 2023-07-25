use completions/with-node/versions.nu *
use modules/fnm/node-versions-dir.nu

# Execute block with Node version
export def with-node [
  version: string@'nu-complete with-node versions'
  block: closure
] {
  let node_path = (
    node-versions-dir | path join $version installation/bin
  )
  let new_path = (
    do $env.ENV_CONVERSIONS.PATH.to_string ($env.PATH | prepend $node_path)
  )
  let env_record = {
    PATH: $new_path
  }

  with-env $env_record $block
}
