export def node-print-packages [
  packages: string    # Literal string (``) of upgraded packages from GitHub diff
] {
  $packages
    | lines
    | uniq
    | parse --regex `"(?P<package>.+)": "(?P<version>.+)",`
    | par-each { |it| $"- ($it | get package)@($it | get version)" }
    | sort
    | to md
}
