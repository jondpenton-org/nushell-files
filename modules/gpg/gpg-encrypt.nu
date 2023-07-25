use completions/gpg/recipients.nu *
use modules/helpers/build-flags.nu

# Encrypts input for GPG recipient
export def main [
  --verbose (-v)

  recipient: string@'nu-complete gpg recipients'
] {
  $in
    | ^gpg (
        build-flags {
          armor: true,
          encrypt: true,
          quiet: (not $verbose),
          recipient: $recipient,
        }
      )
}
