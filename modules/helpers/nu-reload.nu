export def main [] {
  let nu_path = (
    which nu | $in.0.path
  )

  exec $nu_path '--commands' $"cd ($env.PWD | to json); ($nu_path) --login"
}
