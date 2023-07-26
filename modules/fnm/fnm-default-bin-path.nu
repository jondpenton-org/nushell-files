use modules/fnm/fnm-alias-bin-path.nu

export def main [
  # : any -> string?
]: any -> any {
  fnm-alias-bin-path nushell | default (fnm-alias-bin-path default)
}
