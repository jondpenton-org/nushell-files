use completions/open-envrc/file.nu *
use modules/dotenv/open-envrc.nu

# Like `with-env`, but pass .envrc file instead of environment variable set.
export def main [
  file: path@'nu-complete open-envrc file' # .envrc file
  closure: closure # Closure ran with environment variables from .envrc file
] {
  with-env (open-envrc $file) $closure
}
