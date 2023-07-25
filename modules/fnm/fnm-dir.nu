export def main [] {
  ^fnm env --shell bash
    | lines
    | where ('FNM_DIR' in $it)
    | each { parse `export FNM_DIR="{path}"` }
    | flatten
    | $in.path.0
}
