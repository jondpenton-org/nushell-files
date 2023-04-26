export def "nu-complete vscode log levels" [] {
  [`critical`, `error`, `warn`, `info`, `debug`, `trace`, `off`]
}

export def "nu-complete vscode sync" [] {
  [`on`, `off`] | sort
}
