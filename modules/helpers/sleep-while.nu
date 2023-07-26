# Sleep while condition true
export def main [
  --interval: duration # How often `condition` is checked

  condition: closure # Condition to check
] {
  let interval = $interval | default 100ms

  while (do $condition) { sleep $interval }
}
