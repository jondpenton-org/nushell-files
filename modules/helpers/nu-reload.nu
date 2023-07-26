export def main [] {
  exec $nu.current-exe '--commands' (
    $"cd ($env.PWD | to json); ($nu.current-exe) --login"
  )
}
