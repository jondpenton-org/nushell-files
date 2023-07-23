# Builds list of flag strings to pass to command
export def main [
  flags: record # Record with key of flag to its value
] {
  $flags
    | transpose key value
    | each { |it|
        let formatted_key = $"--($it.key)"

        match ($it.value | describe) {
          'bool' => {
            if $it.value {
              $formatted_key
            }
          },
          'float' | 'int' | 'string' => [$formatted_key, $it.value],
          'list<string>' => ($it.value | prepend $formatted_key)
        }
      }
    | flatten
}
