export def main [] {
  try { ^sudo dscacheutil -flushcache }
  ^sudo killall -HUP mDNSResponder
}
