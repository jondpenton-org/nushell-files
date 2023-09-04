export def main []: any -> any {
  try { ^sudo dscacheutil -flushcache }
  ^sudo killall -HUP mDNSResponder
}
