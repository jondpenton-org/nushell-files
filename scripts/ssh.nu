## Externs

export extern "ssh" [
  destination: string@"nu-complete ssh destination"
]

## Completions

def "nu-complete ssh destination" [] {
  open ~/.ssh/config
    | lines
    | where ($it | str starts-with 'Host ')
    | parse 'Host {destination}'
    | get -i destination
    | if ($in | empty?) {
        []
      } else {
        $in
      }
}
