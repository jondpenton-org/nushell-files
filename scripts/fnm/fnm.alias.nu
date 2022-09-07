export alias fnm-default-bin-path = (
  fnm-alias-bin-path `nushell`
    | if ($in | is-empty) {
        fnm-alias-bin-path `default`
      } else {
        $in
      }
)
