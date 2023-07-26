export def main []: nothing -> any {
  ^git reset --hard $"origin/(^git branch --show-current)"
}
