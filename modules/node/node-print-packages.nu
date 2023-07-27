export def main [
  packages: string # Literal string (``) of upgraded packages from GitHub diff
]: nothing -> string {
  $packages
    | lines
    | uniq
    | each { parse --regex `"(?P<package>.+)": "(?P<version>.+)",` }
    | flatten
    | format '- {package}@{version}'
    | sort
    | to md
}
