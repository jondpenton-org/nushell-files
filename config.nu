# Nushell Config File

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
  # Color for nushell primitives
  separator: white,

  # No fg, no bg, attr none effectively turns this off
  leading_trailing_space_bg: { attr: attr_normal },
  header: green_bold,
  empty: blue,

  # Closures can be used to choose colors for specific values. The value
  # (in this case, a bool) is piped into the closure.
  bool: {
    if $in {
      'light_cyan'
    } else {
      'light_gray'
    }
  },
  int: white,
  filesize: {
    if $in == 0b {
      'white'
    } else if $in < 1mb {
      'cyan'
    } else {
      'blue'
    }
  },
  duration: white,
  date: {
    (date now) - $in
      | if $in < 1hr {
          'purple'
        } else if $in < 6hr {
          'red'
        } else if $in < 1day {
          'yellow'
        } else if $in < 3day {
          'green'
        } else if $in < 1wk {
          'light_green'
        } else if $in < 6wk {
          'cyan'
        } else if $in < 52wk {
          'blue'
        } else {
          'dark_gray'
        }
  },
  range: white,
  float: white,
  string: white,
  nothing: white,
  binary: white,
  cellpath: white,
  row_index: green_bold,
  record: white,
  list: white,
  block: white,
  hints: dark_gray,
  search_result: { bg: red, fg: white },

  shape_and: purple_bold,
  shape_binary: purple_bold,
  shape_block: blue_bold,
  shape_bool: light_cyan,
  shape_closure: green_bold,
  shape_custom: green,
  shape_datetime: cyan_bold,
  shape_directory: cyan,
  shape_external: cyan,
  shape_externalarg: green_bold,
  shape_filepath: cyan,
  shape_flag: blue_bold,
  shape_float: purple_bold,

  # Shapes are used to change the cli syntax highlighting
  shape_garbage: { fg: white, bg: red, attr: black },
  shape_globpattern: cyan_bold,
  shape_int: purple_bold,
  shape_internalcall: cyan_bold,
  shape_list: cyan_bold,
  shape_literal: blue,
  shape_match_pattern: green,
  shape_matching_brackets: { attr: attr_underline },
  shape_nothing: light_cyan,
  shape_operator: yellow,
  shape_or: purple_bold,
  shape_pipe: purple_bold,
  shape_range: yellow_bold,
  shape_record: cyan_bold,
  shape_redirection: purple_bold,
  shape_signature: green_bold,
  shape_string: green,
  shape_string_interpolation: cyan_bold,
  shape_table: blue_bold,
  shape_variable: purple,
  shape_vardecl: purple,
}

# The default config record. This is where much of your global configuration
# is setup.
let-env config = {
  bracketed_paste: true, # Enable bracketed paste, currently useless on windows

  # Command that will be used to edit the current line buffer with `CTRL+O`,
  # if unset fallback to `$env.EDITOR` and `$env.VISUAL`
  # buffer_editor: emacs,
  cd: {
    # Allows `cd s/o/f` to expand to `cd some/other/folder`
    abbreviations: true,
  },

  # If you want a light theme, replace `$dark_theme` to `$light_theme`
  color_config: $dark_theme,
  completions: {
    algorithm: fuzzy, # `prefix` or `fuzzy`
    case_sensitive: false, # Set to `true` to enable case-sensitive completions
    external: {
      completer: null,

      # Set to `false` to prevent nushell looking into `$env.PATH` to find
      # more suggestions, `false` recommended for WSL users as this look up
      # may be very slow
      enable: true,

      # Setting it lower can improve completion performance at the cost of
      # omitting some options
      max_results: 100,
    },

    # set this to `false` to prevent partial filling of the prompt
    partial: true,

    # set this to `false` to prevent auto-selecting completions when only
    # one remains
    quick: true,
  },
  cursor_shape: {
    # `block`, `underscore`, `line`, `blink_block`, `blink_underscore`,
    # `blink_line` (`line` is the default)
    emacs: blink_line,

    # `block`, `underscore`, `line`, `blink_block`, `blink_underscore`,
    # `blink_line` (`block` is the default)
    vi_insert: block,

    # `block`, `underscore`, `line`, `blink_block`, `blink_underscore`,
    # `blink_line` (`underscore` is the default)
    vi_normal: underscore,
  },

  # Determines how rendered datetime looks like. Behavior without this
  # configuration point will be to "humanize" the datetime display, showing
  # something like "a day ago."
  datetime_format: {
    # Shows up in displays of variables or other datetime's outside of tables
    normal: '%a, %d %b %Y %H:%M:%S %z',

    # Generally shows up in tabular outputs such as `ls`. Commenting this out
    # will change it to the default human readable datetime format
    table: '%m/%d/%y %I:%M:%S%p',
  },
  edit_mode: emacs, # `emacs`, `vi`
  explore: {
    # command_bar: { fg: '#C4C9C6' bg: '#223311' },
    command_bar_text: '#C4C9C6',
    config: {
      # border_color: white,
      cursor_color: { bg: yellow, fg: black },
      # list_color: green,
    },
    exit_esc: true,
    help_banner: true,
    highlight: { bg: yellow, fg: black },
    status_bar_background: { fg: '#1D1F21' bg: '#C4C9C6' },
    status: {
      # error: { bg: yellow, fg: blue },
      # info: { bg: yellow, fg: blue },
      # warn: { bg: yellow, fg: blue },
    },
    # status_bar_text: { fg: '#C4C9C6' bg: '#223311' },
    table: {
      cursor: true,
      line_head_bottom: true,
      line_head_top: true,
      line_index: true,
      line_shift: true,
      # padding_column_left: 2,
      # padding_column_right: 2,
      # padding_index_left: 2,
      # padding_index_right: 1,
      # selected_cell: { fg: white, bg: '#777777' },
      # selected_column: blue,
      # selected_row: { fg: yellow, bg: '#C1C2A3' },
      show_head: true,
      show_index: true,
      split_line: '#404040',
    },
    try: {
      # border_color: red,
      # highlighted_color: blue,
      # reactive: false,
    },
  },
  filesize: {
    # `b`, `kb`, `kib`, `mb`, `mib`, `gb`, `gib`, `tb`, `tib`, `pb`, `pib`,
    # `eb`, `eib`, `auto`
    format: auto,

    # `true` => KB, MB, GB (ISO standard),
    # `false` => KiB, MiB, GiB (Windows standard)
    metric: true,
  },
  float_precision: 2, # the precision for displaying floats in tables
  footer_mode: '25' # `always`, `never`, `number_of_rows`, `auto`
  history: {
    file_format: plaintext, # `sqlite` or `plaintext`

    # `true` enables history isolation, `false` disables it. `true` will allow
    # the history to be isolated to the current session. `false` will allow
    # the history to be shared across all sessions.
    isolation: true,
    max_size: 100_000, # Session has to be reloaded for this to take effect

    # Enable to share history between multiple sessions, else you have to
    # close the session to write history to file
    sync_on_enter: true,
  },
  hooks: {
    # Ran when a command is not found and output is printed after error message
    command_not_found: {},

    display_output: {
      if (term size).columns >= 100 {
        table --expand
      } else {
        table
      }
    },

    # Ran when environment variable has changed since last REPL input
    env_change: {
      # PWD: [
      #   { |before, after|
      #     null
      #   },
      # ],
    },

    # Ran before REPL input is executed
    pre_execution: [
      # {
      #   null
      # },
    ],

    # Ran before prompt is shown
    pre_prompt: [
      # {
      #   null
      # },
    ],
  },
  keybindings: [
    {
      name: completion_menu,
      event: {
        until: [
          { send: menu, name: completion_menu },
          { send: menunext },
        ],
      },
      keycode: tab,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: completion_previous,
      event: { send: menuprevious },
      keycode: backtab,

      # Note: You can add the same keybinding to all modes by using a list
      mode: [emacs, vi_normal, vi_insert],
      modifier: shift,
    },
    {
      name: history_menu,
      event: { send: menu, name: history_menu },
      keycode: char_r,
      mode: emacs,
      modifier: control,
    },
    {
      name: next_page,
      event: { send: menupagenext },
      keycode: char_x,
      mode: emacs,
      modifier: control,
    },
    {
      name: undo_or_previous_page,
      event: {
        until: [
          { send: menupageprevious },
          { edit: undo },
        ],
      },
      keycode: char_z,
      mode: emacs,
      modifier: control,
    },
    {
      name: yank,
      event: {
        until: [
          { edit: pastecutbufferafter },
        ],
      },
      keycode: char_y,
      mode: emacs,
      modifier: control,
    },
    {
      name: unix-line-discard,
      event: {
        until: [
          { edit: cutfromlinestart },
        ],
      },
      keycode: char_u,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: kill-line,
      event: {
        until: [
          { edit: cuttolineend },
        ],
      },
      keycode: char_k,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },

    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu,
      event: { send: menu, name: commands_menu },
      keycode: char_t,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: vars_menu,
      event: { send: menu, name: vars_menu },
      keycode: char_o,
      mode: [emacs, vi_normal, vi_insert],
      modifier: alt,
    },
    {
      name: commands_with_description,
      event: { send: menu, name: commands_with_description },
      keycode: char_s,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
  ],
  ls: {
    # Enable or disable clickable links. Your terminal has to support links.
    clickable_links: true,

    # Use the LS_COLORS environment variable to colorize output
    use_ls_colors: true,
  },
  menus: [
    # Configuration for default nushell menus
    # Note the lack of source parameter
    {
      name: completion_menu,
      marker: '| ',
      only_buffer_difference: false,
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green,
      },
      type: {
        col_padding: 2,

        # Optional value. If missing all the screen width is used to calculate
        # column width
        col_width: 20,
        columns: 4,
        layout: columnar,
      },
    },
    {
      name: help_menu,
      marker: '? ',
      only_buffer_difference: true,
      type: {
        col_padding: 2,

        # Optional value. If missing all the screen width is used to calculate
        # column width
        col_width: 20,
        columns: 4,
        description_rows: 10,
        layout: description,
        selection_rows: 4,
      },
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green,
      },
    },
    {
      name: history_menu,
      marker: '? ',
      only_buffer_difference: true,
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green,
      },
      type: {
        layout: list,
        page_size: 10,
      },
    },

    # Example of extra menus created using a nushell source
    # Use the source field to create a list of records that populates
    # the menu
    {
      name: commands_menu,
      marker: '# ',
      only_buffer_difference: false,
      source: { |buffer, position|
        scope commands
          | where name =~ $buffer
          | each { |it| { value: $it.name, description: $it.usage } }
      },
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green,
      },
      type: {
        col_padding: 2,
        col_width: 20,
        columns: 4,
        layout: columnar,
      },
    },
    {
      name: commands_with_description,
      marker: '# ',
      only_buffer_difference: true,
      source: { |buffer, position|
        scope commands
          | where name =~ $buffer
          | each { |it| { value: $it.name, description: $it.usage } }
      },
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green,
      },
      type: {
        col_padding: 2,
        col_width: 20,
        columns: 4,
        description_rows: 10,
        layout: description,
        selection_rows: 4,
      },
    },
    {
      name: vars_menu,
      marker: '# ',
      only_buffer_difference: true,
      source: { |buffer, position|
        scope variables
          | where name =~ $buffer
          | sort-by name
          | each { |it| { value: $it.name, description: $it.type } }
      },
      style: {
        description_text: yellow,
        selected_text: green_reverse,
        text: green,
      },
      type: {
        layout: list,
        page_size: 10,
      },
    },
  ],

  # `true` or `false` to enable or disable right prompt to be rendered on last
  # line of the prompt.
  render_right_prompt_on_last_line: false,
  rm: {
    # Always act as if `--trash` was given. Can be overridden
    # with `--permanent`
    always_trash: true,
  },

  # Enables terminal markers and a workaround to arrow keys stop working issue
  shell_integration: true,

  # `true` or `false` to enable or disable the welcome banner at startup
  show_banner: false,
  table: {
    # `always` show indexes, `never` show indexes, `auto` = show indexes when
    # a table has `index` column
    index_mode: always,

    # `basic`, `compact`, `compact_double`, `light`, `thin`, `with_love`,
    # `rounded`, `reinforced`, `heavy`, `none`, `other`
    mode: compact,

    # show `empty list` and `empty record` placeholders for command output
    show_empty: true,
    trim: {
      methodology: wrapping, # `wrapping` or `truncating`
      truncating_suffix: '...', # A suffix used by the 'truncating' methodology

      # A strategy used by the `wrapping` methodology
      wrapping_try_keep_words: true,
    },
  },
  use_ansi_coloring: true,
  use_grid_icons: true,
}

## Repository Updates
do {
  cd $nu.default-config-dir

  ^git fetch --quiet

  if 'Your branch is behind' in (^git status) {
    print $"There is an update to the config. Run `nu-config-update` to update.(char newline)"
  }
}

### Aliases
alias nu-config-update = do { cd $nu.default-config-dir; ^git pull }

# Modules
overlay use --prefix std
overlay use dotenv.nu
overlay use modules/git
overlay use modules/helpers
overlay use math.nu
overlay use ssh.nu

# Should be last overlay. If additional overlays used in `login.nu`, then add
# `overlay use session` after them
overlay new session
