export def "nu-complete gpg recipients" [] {
  gpg --keyid-format long --list-secret-keys
    | lines
    | parse `sec   {algorithm}/{recipient} {rest}`
    | get recipient
}
