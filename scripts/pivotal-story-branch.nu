## Commands

export def psb-s [
  branch_or_story_link: string@"nu-complete git branches"
] {
  psb switch $branch_or_story_link
}

## Externs

export extern "psb switch" [
  branch_or_story_link: string@"nu-complete git branches"
]
