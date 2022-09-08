export alias git-root = (
  git `rev-parse` `--show-toplevel` | str trim
)

export alias grh = git `reset` `--hard`
