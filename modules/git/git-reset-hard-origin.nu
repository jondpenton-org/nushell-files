export def main [] {
  ^git reset --hard $"origin/(^git branch --show-current)"
}
