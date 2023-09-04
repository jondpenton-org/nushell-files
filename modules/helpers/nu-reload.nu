export def main []: any -> any {
  exec $nu.current-exe '--commands' (
    $"cd ($env.PWD | to json); ($nu.current-exe) --login"
  )
}
