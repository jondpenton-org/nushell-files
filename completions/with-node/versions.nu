use modules/fnm/node-versions-dir.nu

export def 'nu-complete with-node versions' [] {
  ls (node-versions-dir) | $in.name | path basename
}
