export def main []: any -> string {
  ^git rev-parse --show-toplevel | str trim
}
