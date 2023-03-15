export alias fnm-default-bin-path = do {
  fnm-alias-bin-path nushell | default (fnm-alias-bin-path default)
}
