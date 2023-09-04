export def main []: any -> string {
  ^fnm env --shell bash
    | lines
    | where ('FNM_DIR' in $it)
    | each { parse `export FNM_DIR="{path}"` }
    | flatten
    | $in.0.path
}
