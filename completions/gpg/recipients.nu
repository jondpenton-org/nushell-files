export def 'nu-complete gpg recipients' [] {
  ^gpg --keyid-format long --list-secret-keys
    | parse --regex `sec.*/(?P<recipient>[\w\d]+).*\n.*\nuid.*<(?P<email>.*)>`
    | rename value description
}
