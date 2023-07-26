use modules/helpers/build-flags.nu

# Decrypts encrypted GPG input
export def main [
  --verbose (-v)
]: string -> any {
  $in | ^gpg (
    build-flags {
      decrypt: true,
      quiet: (not $verbose),
    }
  )
}
