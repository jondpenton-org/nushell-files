# Run a closure on each row of the input list in parallel, mapping to a new list with the results in order.
export def main [
  --threads (-t): int # the number of threads to use

  closure: closure # the closure to run
]: list -> list {
  enumerate
    | par-each { update item { do $closure $in } }
    | sort-by index
    | $in.item
}
