export def main []: nothing -> any {
  try { ^sudo dscacheutil -flushcache }
  ^sudo killall -HUP mDNSResponder
}
