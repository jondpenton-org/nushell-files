use modules/fnm/fnm-alias-bin-path.nu

export def main [] {
  fnm-alias-bin-path nushell | default (fnm-alias-bin-path default)
}
