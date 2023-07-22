overlay use features/carapace.nu
overlay use features/direnv.nu
overlay use features/starship.nu

overlay new session

let-env EDITOR = /opt/homebrew/bin/code

let-env PATH = (
  $env.PATH
    | append /opt/homebrew/bin
    | append /nix/var/nix/profiles/default/bin
    | append /Users/jondpenton/.nix-profile/bin
    | uniq
)
