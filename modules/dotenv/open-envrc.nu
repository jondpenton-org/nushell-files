use completions/open-envrc/file.nu *
use modules/dotenv/open-env.nu
use modules/helpers/table-into-record.nu
use std

# Converts .envrc file into record
export def main [
  file: path@'nu-complete open-envrc file' # .envrc file
]: any -> record {
  # (path | string)? -> record

  open $file
    | lines
    | str replace --all `"` `'`
    | str replace --all --regex `=([\w\d]+)` `='${1}'`
    | reduce --fold {} { |it, acc|
        let variables = (
          if $it starts-with export {
            $it
              | parse --regex `^export\s+(?P<key>[\w_]+)='(?P<value>.*)'`
              | table-into-record
          } else if $it starts-with source_env {
            $it
              | parse --regex `^source_env(?:_if_exists)?\s+(?P<name>.*)`
              | $in.name.0
              | path expand
              | open-envrc $in
          } else if $it starts-with dotenv {
            $file
              | path dirname
              | path join (
                  $it
                    | parse 'dotenv {name}'
                    | $in.name.0
                )
              | path expand
              | open-env $in
          }
        )

        if ($variables | is-empty) {
          $acc
        } else {
          $acc | merge $variables
        }
      }
}
