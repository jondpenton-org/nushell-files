# By default, output is written to stdout.
# Stdin is read if it is piped to Prettier and no files are given.
export extern main [
  --arrow-parens: string@"nu-complete prettier arrow-parens"                                    # Include parentheses around a sole arrow function parameter. Defaults to always.
  --check (-c)                                                                                  # Check if the given files are formatted, print a human-friendly summary message and paths to unformatted files (see also --list-different).
  --config: path                                                                                # Path to a Prettier configuration file (.prettierrc, package.json, prettier.config.js).
  --config-precedence: string@"nu-complete prettier config-precedence"                          # Define in which order config files and CLI options should be evaluated. Defaults to cli-override.
  --cursor-offset: int                                                                          # Print (to stderr) where a cursor at the given position would move to after formatting. This option cannot be used with --range-start and --range-end. Defaults to -1.
  --embedded-language-formatting: string@"nu-complete prettier embedded-language-formatting"    # Control how Prettier formats quoted code embedded in the file. Defaults to auto.
  --end-of-line: string@"nu-complete prettier end-of-line"                                      # Which end of line characters to apply. Defaults to lf.
  --file-info: path                                                                             # Extract the following info (as JSON) for a given file path. Reported fields: * ignored (boolean) - true if file path is filtered by --ignore-path   * inferredParser (string | null) - name of parser inferred from file path
  --find-config-path: path                                                                      # Find and print the path to a configuration file for the given input file.
  --html-whitespace-sensitivity: string@"nu-complete prettier html-whitespace-sensitivity"      # How to handle whitespaces in HTML. Defaults to css.
  --ignore-path: path                                                                           # Path to a file with patterns describing files to ignore. Defaults to .prettierignore.
  --ignore-unknown (-u)                                                                         # Ignore unknown files.
  --insert-pragma: bool                                                                         # Insert @format pragma into file's first docblock comment. Defaults to false.
  --jsx-bracket-same-line: bool                                                                 # Put > on the last line instead of at a new line. Defaults to false.
  --jsx-single-quote: bool                                                                      # Use single quotes in JSX. Defaults to false.
  --list-different (-l)                                                                         # Print the names of files that are different from Prettier's formatting (see also --check).
  --loglevel: string@"nu-complete prettier loglevel"                                            # What level of logs to report. Defaults to log.
  --no-bracket-spacing: bool                                                                    # Do not print spaces between brackets.
  --no-color: bool                                                                              # Do not colorize error messages.
  --no-config: bool                                                                             # Do not look for a configuration file.
  --no-editorconfig: bool                                                                       # Don't take .editorconfig into account when parsing configuration.
  --no-error-on-unmatched-pattern: bool                                                         # Prevent errors when pattern is unmatched.
  --no-semi: bool                                                                               # Do not print semicolons, except at the beginning of lines which may need them.
  --parser: string@"nu-complete prettier parser"                                                # Which parser to use.
  --plugin: path                                                                                # Add a plugin. Multiple plugins can be passed as separate `--plugin`s. Defaults to [].
  --plugin-search-dir: path                                                                     # Custom directory that contains prettier plugins in node_modules subdirectory. Overrides default behavior when plugins are searched relatively to the location of Prettier. Multiple values are accepted. Defaults to [].
  --print-width: int                                                                            # The line length where Prettier will try wrap. Defaults to 80.
  --prose-wrap: string@"nu-complete prettier prose-wrap"                                        # How to wrap prose. Defaults to preserve.
  --quote-props: string@"nu-complete prettier quote-props"                                      # Change when properties in objects are quoted. Defaults to as-needed.
  --range-end: int                                                                              # Format code ending at a given character offset (exclusive). The range will extend forwards to the end of the selected statement. This option cannot be used with --cursor-offset. Defaults to Infinity. This option cannot be used with --cursor-offset. Defaults to 0.
  --require-pragma: bool                                                                        # Require either '@prettier' or '@format' to be present in the file's first docblock comment in order for it to be formatted. Defaults to false.
  --single-quote: bool                                                                          # Use single quotes instead of double quotes. Defaults to false.
  --stdin-filepath: path                                                                        # Path to the file to pretend that stdin comes from.
  --support-info: bool                                                                          # Print support information as JSON.
  --tab-width: int                                                                              # Number of spaces per indentation level. Defaults to 2.
  --trailing-comma: string@"nu-complete prettier trailing-comma"                                # Print trailing commas wherever possible when multi-line. Defaults to es5.
  --use-tabs: bool                                                                              # Indent with tabs instead of spaces. Defaults to false.
  --version (-v)                                                                                # Print Prettier version.
  --vue-indent-script-and-style: bool                                                           # Indent script and style tags in Vue files. Defaults to false.
  --with-node-modules: bool                                                                     # Process files inside 'node_modules' directory.
  --write (-w)                                                                                  # Edit files in-place. (Beware!)
]

def "nu-complete prettier arrow-parens" [] {
  [always, avoid]
}

def "nu-complete prettier config-precedence" [] {
  [cli-override, file-override, prefer-file]
}

def "nu-complete prettier embedded-language-formatting" [] {
  [auto, off]
}

def "nu-complete prettier end-of-line" [] {
  [auto, cr, crlf, lf]
}

def "nu-complete prettier html-whitespace-sensitivity" [] {
  [css, ignore, strict]
}

def "nu-complete prettier loglevel" [] {
  [debug, error, log, silent, warn]
}

def "nu-complete prettier parser" [] {
  [
    angular, babel, babel-flow, babel-ts, css, espree, flow, glimmer, graphql,
    html, json, json-stringify, json5, less, lwc, markdown, mdx, meriyah, scss,
    typescript, vue, yaml,
  ]
}

def "nu-complete prettier prose-wrap" [] {
  [always, never, preserve]
}

def "nu-complete prettier quote-props" [] {
  [as-needed, consistent, preserve]
}

def "nu-complete prettier trailing-comma" [] {
  [all, es5, none]
}
