use std iter

export def main [
  repo: string@'nu-complete ghq repos'
] {
  ^ghq root | lines | each { path join $repo } | iter find { path exists }
}

def 'nu-complete ghq repos' [] {
  ^ghq list | lines
}
