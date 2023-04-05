export def node-print-packages [
  packages: string    # Literal string (``) of upgraded packages from GitHub diff
] {
  $packages
    | lines
    | uniq
    | par-each { || parse --regex `"(?P<package>.+)": "(?P<version>.+)",` }
    | flatten
    | par-each { |it| $"- ($it.package)@($it.version)" }
    | sort
    | to md
}
