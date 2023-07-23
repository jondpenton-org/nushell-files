export def main [
  key: string = key
  value: string = value
] {
  select $key $value
    | transpose --header-row
    | $in.0?
    | default {}
}
