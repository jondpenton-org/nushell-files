use completions/open-envrc/file.nu *
use modules/dotenv/open-env.nu
use modules/helpers/table-into-record.nu
use modules/helpers/when.nu

# Converts .envrc file into record
export def main [
  file?: path@'nu-complete open-envrc file' # .envrc file
]: any -> record {
  let file = (
    $in | when { |it|
      ($it | is-empty) or (($it | describe) not-in [path, string])
    } $file
  )

  if ($file | is-empty) {
    error make {
      msg: (
        'either the file parameter or a path/string pipeline input must be provided'
      ),
    }
  }

  open $file
    | lines
    | str replace --all --string `"` `'`
    | str replace --all `=([\w\d]+)` `='${1}'`
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
              | main $in
          } else if $it starts-with dotenv {
            $file
              | path dirname
              | path join (
                  $it
                    | parse 'dotenv {name}'
                    | $in.name.0
                )
              | path expand
              | open-env
          }
        )

        if ($variables | is-empty) {
          $acc
        } else {
          $acc | merge $variables
        }
      }
}
