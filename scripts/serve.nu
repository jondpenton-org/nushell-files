## Externs

# Static file serving and directory listing
export extern main [
  --config (-c): path     # Specify custom path to `serve.json`
  --cors (-C)             # Enable CORS, sets `Access-Control-Allow-Origin` to `*`
  --debug (-d)            # Show debugging information
  --help                  # Shows this help message
  --listen (-l): string   # Specify a URI endpoint on which to listen (see below) - more than one may be specified to listen in multiple places
  --no-clipboard (-n)     # Do not copy the local address to the clipboard
  --no-compression (-u)   # Do not compress files
  --no-etag               # Send `Last-Modified` header instead of `ETag`
  --no-port-switching     # Do not open a port other than the one specified when it's taken.
  -p: int                 # Specify custom port
  --single (-s)           # Rewrite all not-found requests to `index.html`
  --ssl-key: path         # Optional path to the SSL/TLS certificate's private key
  --ssl-pass: path        # Optional path to the SSL/TLS certificate's passphrase
  --symlinks (-S)         # Resolve symlinks instead of showing 404 errors
  --version (-v)          # Displays the current version of serve

  directory?: path        # By default, serve will listen on 0.0.0.0:3000 and serve the current working directory on that address.
]
