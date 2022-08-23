## Externs

# Visual Studio Code
export extern code [
  ...paths: path

  --add (-a): path # Add folder(s) to the last active window.
  --category: string # Filters installed extensions by provided category, when using --list-extensions.
  --diff (-d): any # <file> <file> Compare two files with each other.
  --disable-extension: string # Disable an extension.
  --disable-extensions # Disable all installed extensions.
  --disable-gpu # Disable GPU hardware acceleration.
  --enable-proposed-api: any # Enables proposed API features for extensions. Can receive one or more extension IDs to enable individually.
  --extensions-dir: path # Set the root path for extensions.
  --goto (-g): string # <file:line[:character]> Open a file at the path on the specified line and character position.
  --help (-h) # Print usage.
  --inspect-brk-extensions: int # Allow debugging and profiling of extensions with the extension host being paused after start. Check the developer tools for the connection URI.
  --inspect-extensions: int # Allow debugging and profiling of extensions. Check the developer tools for the connection URI.
  --install-extension: any # <ext-id | path> Installs or updates an extension. The argument is either an extension id or a path to a VSIX. The identifier of an extension is '${publisher}.${name}'. Use '--force' argument to update to latest version. To install a specific version provide '@${version}'. For example: 'vscode.csharp@1.2.3'.
  --list-extensions # List the installed extensions.
  --locale: string # The locale to use (e.g. en-US or zh-TW).
  --log: string@"nu-complete vscode log levels" # Log level to use. Default is 'info'.
  --max-memory: int # Max memory size for a window (in Mbytes).
  --merge (-m): any # <path1> <path2> <base> <result> Perform a three-way merge by providing paths for two modified versions of a file, the common origin of both modified versions and the output file to save merge results.
  --new-window (-n) # Force to open a new window.
  --pre-release # Installs the pre-release version of the extension, when using --install-extension
  --prof-startup # Run CPU profiler during startup.
  --reuse-window (-r) # Force to open a file or folder in an already opened window.
  --show-versions # Show versions of installed extensions, when using --list-extensions.
  --status (-s) # Print process usage and diagnostics information.
  --sync: string@"nu-complete vscode sync" # Turn sync on or off.
  --telemetry # Shows all telemetry events which VS code collects.
  --uninstall-extension: string # <ext-id> Uninstalls an extension.
  --user-data-dir: path # Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code.
  --verbose # Print verbose output (implies --wait).
  --version (-v) # Print version.
  --wait (-w) # Wait for the files to be closed before returning.
]

## Completions

def "nu-complete vscode log levels" [] {
  ['critical', 'error', 'warn', 'info', 'debug', 'trace', 'off']
}

def "nu-complete vscode sync" [] {
  ['on', 'off'] | sort
}
