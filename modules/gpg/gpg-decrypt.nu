use modules/helpers/build-flags.nu

# Decrypts encrypted GPG input
export def main [
  --verbose (-v)
]: string -> any {
  ^gpg (
    build-flags {
      decrypt: true,
      quiet: (not $verbose),
    }
  )
}
