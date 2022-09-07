use helpers.nu build-flags

## Commands
# Decrypts encrypted GPG input
export def gpg-decrypt [
  --verbose (-v)
] {
  let initial_in = $in
  let flags = build-flags {
    decrypt: true,
    quiet: (not $verbose),
  }

  $initial_in | gpg $flags
}

# Encrypts input for GPG recipient
export def gpg-encrypt [
  recipient: string@"nu-complete gpg recipients"
  --verbose (-v)
] {
  let initial_in = $in
  let flags = build-flags {
    armor: true,
    encrypt: true,
    quiet: (not $verbose),
    recipient: $recipient,
  }

  $initial_in | gpg $flags
}

## Completions

def "nu-complete gpg recipients" [] {
  gpg --list-secret-keys --keyid-format long
    | lines
    | parse 'sec   {algorithm}/{recipient} {rest}'
    | get recipient
}
