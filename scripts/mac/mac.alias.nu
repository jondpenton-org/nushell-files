export alias reset-dns = do { ||
  try { || sudo dscacheutil -flushcache }
  sudo killall -HUP mDNSResponder
}
