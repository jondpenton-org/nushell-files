export def main []: any -> bool {
  ^git status --porcelain | is-empty
}
