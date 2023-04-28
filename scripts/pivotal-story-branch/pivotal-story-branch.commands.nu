use ../git/git.completion.nu `nu-complete git branches`

export def psb-s [
  branch_or_story_link: string@'nu-complete git branches'
] {
  psb switch $branch_or_story_link
}
