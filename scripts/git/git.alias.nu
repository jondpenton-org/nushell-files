export alias git-reset = git reset --hard
export alias git-reset-origin = git-reset $'origin/(git branch --show-current)'
export alias git-root = (
  git rev-parse --show-toplevel | str trim
)

export alias grh = git-reset
export alias grho = git-reset-origin
export alias is-git-clean = (git status --porcelain | is-empty)
