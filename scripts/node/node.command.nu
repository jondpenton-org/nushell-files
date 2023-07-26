export def node-print-packages [
  packages: string # Literal string (``) of upgraded packages from GitHub diff
] {
  $packages
    | lines
    | uniq
    | each { parse --regex `"(?P<package>.+)": "(?P<version>.+)",` }
    | flatten
    | format '- {package}@{version}'
    | sort
    | to md
}
