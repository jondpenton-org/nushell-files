use completions/open-env/file.nu *
use modules/helpers/table-into-record.nu
use std

# Converts .env file into record
export def main [
  file: path@'nu-complete open-env file' # .env file
]: any -> record {
  # (path | string)? -> record

  open $file
    | lines
    | where ($it !~ `^\w+=".*\$[A-Z].*"`) # Exclude lines like `PATH="<path>:$PATH"`
    | str replace --all --regex `^(\w+)=([^'"]+)` `${1}='${2}'` # `PORT=3000` to `PORT='3000'`
    | str replace --all --regex `^(\w+)="(.*)"` `${1}='${2}'` # `PORT="3000"` to `PORT='3000'`
    | each { parse --regex `^(?P<key>\w+)='(?P<value>.*)'` }
    | flatten
    | table-into-record
}
