# Check if an external command exists
export def main [
  command_name: string
] {
  which --all $command_name | any { $in.type == 'external' }
}
