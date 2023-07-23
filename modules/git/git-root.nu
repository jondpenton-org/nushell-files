export def main [] {
  ^git rev-parse --show-toplevel | str trim
}
