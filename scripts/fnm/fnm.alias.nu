export alias fnm-default-bin-path = (
  fnm-alias-bin-path nushell | default (fnm-alias-bin-path default)
)
