# Compares files by their SHA256 hash and prompts the user to select which
# files to keep.
export def main [
  files: list<path>
]: any -> any {
  $files
    | filter { path type | $in == 'file' }
    | group-by { open --raw | hash sha256 }
    | transpose hash files
    | filter { ($in.files | length) > 1 } # hash has duplicate(s)
    | each { |it|
        let keep_name = $it.files | input list 'Select file to keep'

        $it.files | filter { $in != $keep_name } # duplicates to delete
      }
    | flatten
    | each { rm $in }
}
