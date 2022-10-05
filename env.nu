def color-string [ansi_code: any, text: string] {
  [
    (ansi $ansi_code),
    $text,
    (ansi reset)
  ] | str join
}

let-env STARSHIP_SHELL = `nu`

def create_left_prompt [] {
  starship prompt --cmd-duration $env.CMD_DURATION_MS $"--status=($env.LAST_EXIT_CODE)"
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = ``

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = ``
let-env PROMPT_INDICATOR_VI_INSERT = `: `
let-env PROMPT_INDICATOR_VI_NORMAL = `〉`
let-env PROMPT_MULTILINE_INDICATOR = `::: `


# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external
#   commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  PATH: {
    from_string: { |str|
      $str
        | split row (char env_sep)
        | path expand --no-symlink
    }
    to_string: { |list|
      $list
        | path expand --no-symlink
        | str join (char env_sep)
    }
  }
  Path: {
    from_string: { |str|
      $str
        | split row (char env_sep)
        | path expand --no-symlink
    }
    to_string: { |list|
      $list
        | path expand --no-symlink
        | str join (char env_sep)
    }
  }
}

let-env NU_DIR = (
  $nu.config-path | path dirname
)

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
  ($env.NU_DIR | path join `scripts`)
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
  ($env.NU_DIR | path join `plugins`)
]
