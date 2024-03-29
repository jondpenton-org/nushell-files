use modules/fnm/fnm-dir.nu

export def main [
  alias: string@'nu-complete fnm aliases'

  # : any -> string?
]: any -> any {
  let alias_dir = (
    fnm-dir
      | path join aliases
      | ls $in
      | where name ends-with $alias
      | $in.name.0?
  )

  if ($alias_dir | is-empty) {
    return
  }

  $alias_dir | path join bin
}

def 'nu-complete fnm aliases' []: any -> list<string> {
  ls (fnm-dir | path join aliases)
    | $in.name
    | path basename
    | sort
}
