# Returns integer formatted as string with commas
export def "math format" [
  --separator (-s): string = `,`
] {
  let input = $in
  let input_type = ($input | describe)

  if $input_type != `int` {
    error make {
      label: (
        metadata $input
          | get span
          | merge {
              text: $'expected int, received ($input_type)',
            }
      ),
      msg: $'Input type "($input_type)" not supported.',
    }
  }

  $input
    | into string
    | split chars
    | reverse
    | group 3
    | reverse
    | each {
        reverse | str join
      }
    | str join $separator
}
