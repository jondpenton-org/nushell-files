use modules/fnm/fnm-dir.nu

export def main [] {
  fnm-dir | path join node-versions
}
