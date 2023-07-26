export def main []: nothing -> string {
  ^git rev-parse --show-toplevel | str trim
}
