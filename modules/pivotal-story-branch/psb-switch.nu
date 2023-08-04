export def main [
  branch_or_story_link: string
] {
  ^psb switch $branch_or_story_link
}
