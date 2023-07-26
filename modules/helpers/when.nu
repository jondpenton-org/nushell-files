# When predicate evaluates to `true`, returns consequent or `do $consequent`
export def main [
  predicate: closure # Closure that returns `bool`. Evaluated as a `do` closure with input passed as parameter and input.
  consequent # If closure, evaluated as a `do` closure with input passed as parameter and input.
]: any -> any {
  let input = $in

  if ($input | do $predicate $input) != true {
    return $input
  }

  if ($consequent | describe) != 'closure' {
    return $consequent
  }

  $input | do $consequent $input
}
