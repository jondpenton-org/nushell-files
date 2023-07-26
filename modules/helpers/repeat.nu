# Repeat closure # of times
export def main [
  times: int # Times to repeat $closure
  closure: closure
]: any -> list {
  1..$times | each $closure
}
