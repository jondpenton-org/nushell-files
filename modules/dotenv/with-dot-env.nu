use completions/open-env/file.nu *
use modules/dotenv/open-env.nu

# Like `with-env`, but pass .env file instead of environment variable set
export def main [
  file: path@'nu-complete open-env file' # .env file
  block: closure # Block ran with variables in passed file
]: any -> any {
  with-env (open-env $file) $block
}
