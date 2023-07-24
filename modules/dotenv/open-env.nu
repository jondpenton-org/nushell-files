use completions/open-env/file.nu
use modules/git/git-root.nu
use modules/helpers/table-into-record.nu
use modules/helpers/when.nu

# Converts .env file into record
export def main [
  file?: path@'nu-complete open-env file' # .env file
] {
  let file = (
    $in
      | when { |it|
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
    | where ($it !~ `^\w+=".*\$[A-Z].*"`) # Exclude lines like `PATH="<path>:$PATH"`
    | str replace --all `^(\w+)=([^'"]+)` `${1}='${2}'` # `PORT=3000` to `PORT='3000'`
    | str replace --all `^(\w+)="(.*)"` `${1}='${2}'` # `PORT="3000"` to `PORT='3000'`
    | each { parse --regex `^(?P<key>\w+)='(?P<value>.*)'` }
    | flatten
    | table-into-record
}

