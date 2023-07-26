use modules/helpers/external-command-exists.nu

export-env {
  let config_completer = {
    completions: {
      external: {
        completer: { |spans|
          # If the current command is an alias, get its expansion
          let expanded_alias = (
            scope aliases | where name == $spans.0 | $in.0?.expansion?
          )

          # Overwrite `$spans` with the expanded alias if it exists
          let spans = (
            if $expanded_alias != null {
              # Put the first word of the expanded alias first in the span
              $spans
                | skip 1
                | prepend ($expanded_alias | split words)
            } else {
              $spans
            }
          )

          if (external-command-exists carapace) {
            ^carapace $spans.0 nushell $spans
              | from json
              | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) {
                  $in
                }
          }
        }
      }
    }
  }

  $env.config = ($env.config | merge $config_completer)
}
