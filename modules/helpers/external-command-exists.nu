export def main [
  command_name: string
] {
  which --all $command_name | any { $in.path starts-with / }
}