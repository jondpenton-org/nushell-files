export def node-print-packages [
  packages: string # Literal string (``) of upgraded packages from GitHub diff
] {
  $packages
    | lines
    | uniq
    | each { parse --regex `"(?P<package>.+)": "(?P<version>.+)",` }
    | flatten
    | each { $"- ($in.package)@($in.version)" }
    | sort
    | to md
}
