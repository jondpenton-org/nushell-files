use ../helpers.nu build-flags
use gpg.completion.nu `nu-complete gpg recipients`

# Decrypts encrypted GPG input
export def gpg-decrypt [
  --verbose (-v)
] {
  let initial_in = $in
  let flags = (
    build-flags {
      decrypt: true,
      quiet: (not $verbose),
    }
  )

  $initial_in | gpg $flags
}

# Encrypts input for GPG recipient
export def gpg-encrypt [
  --verbose (-v)

  recipient: string@'nu-complete gpg recipients'
] {
  let initial_in = $in
  let flags = (
    build-flags {
      armor: true,
      encrypt: true,
      quiet: (not $verbose),
      recipient: $recipient,
    }
  )

  $initial_in | gpg $flags
}
