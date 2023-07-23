export def main [] {
  ^git status --porcelain | is-empty
}
