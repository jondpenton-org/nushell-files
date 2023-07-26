# Nushell Environment Config File

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {
  let home = $env.HOME? | default $env.USERPROFILE? | default ''
  let dir = $env.PWD | str replace --string $home ~
  let path_color = (
    if (is-admin) {
      ansi red_bold
    } else {
      ansi green_bold
    }
  )
  let separator_color = (
    if (is-admin) {
      ansi light_red_bold
    } else {
      ansi light_green_bold
    }
  )
  let path_segment = $"($path_color)($dir)"
  let separator_segment = $"($separator_color)/($path_color)"

  $path_segment | str replace --all --string (char path_sep) $separator_segment
}

$env.PROMPT_COMMAND_RIGHT = {
  let time_segment_color = $"(ansi reset)(ansi magenta)"
  let time_separator_color = $"(ansi reset)(ansi green)"
  let time_miridian_color = $"(ansi reset)(ansi magenta_underline)"

  # create a right prompt in magenta with green separators and am/pm underlined
  let time_segment = (
    [
      $time_segment_color,
      (date now | date format '%Y/%m/%d %r'),
    ]
      | str join
      | str replace --all '([/:])' $"($time_separator_color)${1}($time_segment_color)"
      | str replace --all '([AP]M)' $"($time_miridian_color)${1}"
  )
  let last_exit_code_segment = (
    if $env.LAST_EXIT_CODE != 0 {
      $"(ansi reset)(ansi red_bold)($env.LAST_EXIT_CODE)"
    } else {
      ''
    }
  )

  $"($last_exit_code_segment) ($time_segment)"
}

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = { ' > ' }
$env.PROMPT_INDICATOR_VI_INSERT = { ' : ' }
$env.PROMPT_INDICATOR_VI_NORMAL = { ' > ' }
$env.PROMPT_MULTILINE_INDICATOR = { '::: ' }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  PATH: {
    from_string: { |str|
      $str
        | split row (char env_sep)
        | path expand --no-symlink
        | uniq
    },
    to_string: { |list|
      $list
        | path expand --no-symlink
        | str join (char env_sep)
    },
  },
  Path: {
    from_string: { |str|
      $str
        | split row (char env_sep)
        | path expand --no-symlink
        | uniq
    },
    to_string: { |list|
      $list
        | path expand --no-symlink
        | str join (char env_sep)
    },
  },
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
  $nu.default-config-dir,
  ($nu.default-config-dir | path join scripts),
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
  ($nu.default-config-dir | path join plugins),
]

# Features
## Starship
try {
  mkdir ~/.cache/starship
  ^starship init nu | save --force ~/.cache/starship/init.nu
}
