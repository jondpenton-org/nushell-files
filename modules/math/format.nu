# Returns integer formatted as string with commas
export def main [
  --separator (-s): string = ','
]: int -> string {
  into string
    | split chars
    | reverse
    | group 3
    | reverse
    | each { reverse | str join }
    | str join $separator
}
