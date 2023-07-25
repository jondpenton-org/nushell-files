use modules/fnm/fnm-alias-bin-path.nu

export def fnm-default-bin-path [] {
  fnm-alias-bin-path nushell | default (fnm-alias-bin-path default)
}
