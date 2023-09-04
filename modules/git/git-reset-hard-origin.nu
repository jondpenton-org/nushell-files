export def main []: any -> any {
  ^git reset --hard $"origin/(^git branch --show-current)"
}
