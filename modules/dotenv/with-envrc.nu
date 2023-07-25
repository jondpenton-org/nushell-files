use completions/open-envrc/file.nu *
use modules/dotenv/open-envrc.nu

# Like `with-env`, but pass .envrc file instead of environment variable set.
export def main [
  file: path@'nu-complete open-envrc file' # .envrc file
  block: closure # Block ran with variables in passed file
] {
  with-env (open-envrc $file) $block
}
