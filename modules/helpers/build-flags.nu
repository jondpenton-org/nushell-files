# Builds list of flag strings to pass to command
export def main [
  flags: record # Record with key of flag to its value
]: any -> list<string> {
  $flags
    | transpose key value
    | each { |it|
        let formatted_key = $"--($it.key)"

        match ($it.value | describe) {
          $type if ($type == 'bool' and $it.value) => $formatted_key,
          'float' | 'int' | 'string' => [$formatted_key, $it.value],
          'list<string>' => ($it.value | prepend $formatted_key)
        }
      }
    | flatten
}
