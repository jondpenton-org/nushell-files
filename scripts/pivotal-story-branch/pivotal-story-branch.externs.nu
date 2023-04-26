use ../git/git.completion.nu `nu-complete git branches`

# TODO: Remove
def "nu-complete git branches" [] {
  ^git branch
    | lines
    | str replace ^\* ``
    | str trim
}

export extern "psb switch" [
  branch_or_story_link: string@'nu-complete git branches'
]
