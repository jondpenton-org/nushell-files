export-env {
  let config_completer = {
    completions: {
      external: {
        completer: { |spans|
          if not (which carapace | is-empty) {
            carapace $spans.0 nushell $spans | from json
          }
        }
      }
    }
  }

  let-env config = ($env.config | merge $config_completer)
}
