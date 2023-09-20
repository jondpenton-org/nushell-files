export def main [] {
	^git rev-parse --abbrev-ref refs/remotes/origin/HEAD
		| str trim
		| str replace origin/ ''
}
