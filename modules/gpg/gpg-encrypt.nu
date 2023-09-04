use modules/helpers/build-flags.nu

# Encrypts input for GPG recipient
export def main [
  --verbose (-v)

  recipient: string@'nu-complete gpg recipients'
]: string -> string {
  ^gpg (
    build-flags {
      armor: true,
      encrypt: true,
      quiet: (not $verbose),
      recipient: $recipient,
    }
  )
}

def 'nu-complete gpg recipients' [
  # : any -> table<value: string, description: string>
]: any -> table {
  ^gpg --keyid-format long --list-secret-keys
    | parse --regex `sec.*/(?P<recipient>[\w\d]+).*\n.*\nuid.*<(?P<email>.*)>`
    | rename value description
}
