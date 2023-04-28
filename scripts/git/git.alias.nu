export alias git-reset-hard = ^git reset --hard
export alias git-reset-hard-origin = do {
  git-reset-hard $"origin/(^git branch --show-current)"
}

export alias git-root = do {
  ^git rev-parse --show-toplevel | str trim
}

export alias grh = git-reset-hard
export alias grho = git-reset-hard-origin
export alias is-git-clean = do { ^git status --porcelain | is-empty }
