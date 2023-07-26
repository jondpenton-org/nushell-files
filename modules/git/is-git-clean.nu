export def main []: nothing -> bool {
  ^git status --porcelain | is-empty
}
