# Repeat block # of times
export def main [
  times: int # Times to repeat $block
  block: closure
] {
  1..$times | each $block
}
