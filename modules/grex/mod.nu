# grex generates regular expressions from user-provided test cases.
export extern main [
  --digits (-d) # Converts any Unicode decimal digit to \d. Takes precedence over --words if both are set. Decimal digits are converted to \d, remaining word characters to \w. Takes precedence over --non-spaces if both are set. Decimal digits are converted to \d, remaining non-space characters to \S.
  --repetitions (-r) # Detects repeated non-overlapping substrings and converts them to {min,max} quantifier notation

  ...inputs: string
]
