use modules/fnm/fnm-dir.nu

export def main []: any -> string {
  fnm-dir | path join node-versions
}
