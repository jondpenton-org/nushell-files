# Check if an external command exists
export def main [
  command_name: string
]: nothing -> bool {
  which --all $command_name | any { $in.type == 'external' }
}
