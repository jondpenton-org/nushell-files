overlay use features/carapace.nu
overlay use features/direnv.nu
overlay use features/starship.nu

# overlay use modules/ffmpeg
# overlay use modules/fnm
# overlay use modules/ghq
# overlay use modules/gpg
# overlay use modules/grex
# overlay use modules/mac
# overlay use modules/node
# overlay use modules/nx
# overlay use modules/pivotal-story-branch
# overlay use scripts/pnpm.nu
# overlay use scripts/postgres.nu
# overlay use scripts/prettier.nu
# overlay use scripts/rush.nu
# overlay use scripts/serve.nu
# overlay use scripts/vry.nu
# overlay use scripts/vscode.nu
# overlay use scripts/yarn.nu

overlay new session

$env.EDITOR = /opt/homebrew/bin/code

$env.PATH = (
  $env.PATH
    | append /opt/homebrew/bin
    | append /nix/var/nix/profiles/default/bin
    | append /Users/jondpenton/.nix-profile/bin
    | uniq
)
