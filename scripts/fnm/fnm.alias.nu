use fnm.command.nu fnm-alias-bin-path

export alias fnm-default-bin-path = do {
  fnm-alias-bin-path nushell | default (fnm-alias-bin-path default)
}
