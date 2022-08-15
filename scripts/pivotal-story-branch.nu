## Commands

export def psb-s [
  branch-or-story-link: string@"nu-complete git branches"
] {
  psb switch $branch-or-story-link
}

## Externs

export extern "psb switch" [
  branch-or-story-link: string@"nu-complete git branches"
]
