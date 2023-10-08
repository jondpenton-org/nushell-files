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
$env.config = {
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
    command_bar_text: '#C4C9C6',
    config: {
      border_color: { fg: white },
      cursor_color: { fg: black, bg: light_yellow },
    },
    highlight: { bg: yellow, fg: black },
    status_bar_background: { fg: '#1D1F21' bg: '#C4C9C6' },
    status: {
      error: { fg: white, bg: red },
      info: {},
      warn: {},
    },
    table: {
      cursor: true,
      line_head_bottom: true,
      line_head_top: true,
      line_index: true,
      line_shift: true,
      selected_cell: {},
      selected_column: {},
      selected_row: {},
      split_line: { fg: '#404040' },
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
    file_format: sqlite, # `sqlite` or `plaintext`

    # only available with `sqlite` `file_format`. `true` enables history
    # isolation, `false` disables it. `true` will allow the history to be
    # isolated to the current session using up/down arrows. `false` will allow
    # the history to be shared across all sessions.
    isolation: false,
    max_size: 100_000, # Session has to be reloaded for this to take effect

    # Enable to share history between multiple sessions, else you have to
    # close the session to write history to file
    sync_on_enter: true,
  },
  hooks: {
    # Ran when a command is not found and output is printed after error message
    command_not_found: {},

    # Ran before the output of a command is drawn
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
      name: cancel_command,
      event: { send: ctrlc },
      keycode: char_c,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: capitalize_char,
      event: { edit: capitalizechar },
      keycode: char_c,
      mode: emacs,
      modifier: alt,
    },
    {
      name: clear_screen,
      event: { send: clearscreen },
      keycode: char_l,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: completion_menu,
      event: {
        until: [
          { send: menu, name: completion_menu },
          { send: menunext },
        ],
      },
      keycode: tab,
      mode: [emacs vi_normal vi_insert],
      modifier: none,
    },
    {
      name: completion_previous_menu,
      event: { send: menuprevious },
      keycode: backtab,
      mode: [emacs, vi_normal, vi_insert],
      modifier: shift,
    },
    {
      name: cut_line_from_start,
      event: { edit: cutfromstart },
      keycode: char_u,
      mode: emacs,
      modifier: control,
    },
    {
      name: cut_line_to_end,
      event: { edit: cuttoend },
      keycode: char_k,
      mode: emacs,
      modifier: control,
    },
    {
      name: cut_word_left,
      event: { edit: cutwordleft },
      keycode: char_w,
      mode: emacs,
      modifier: control,
    },
    {
      name: cut_word_to_right,
      event: { edit: cutwordright },
      keycode: char_d,
      mode: emacs,
      modifier: alt,
    },
    {
      name: delete_one_character_backward,
      event: { edit: backspace },
      keycode: backspace,
      mode: [emacs, vi_insert],
      modifier: none,
    },
    {
      name: delete_one_character_forward,
      event: { edit: delete },
      keycode: delete,
      mode: [emacs, vi_insert],
      modifier: none,
    },
    {
      name: delete_one_character_forward,
      event: { edit: delete },
      keycode: delete,
      mode: [emacs, vi_insert],
      modifier: control,
    },
    {
      name: delete_one_character_forward,
      event: { edit: backspace },
      keycode: char_h,
      mode: [emacs, vi_insert],
      modifier: control,
    },
    {
      name: delete_one_word_backward,
      event: { edit: backspaceword },
      keycode: backspace,
      mode: [emacs, vi_insert],
      modifier: control,
    },
    {
      name: delete_one_word_backward,
      event: { edit: backspaceword },
      keycode: char_w,
      mode: [emacs, vi_insert],
      modifier: control,
    },
    {
      name: delete_one_word_backward,
      event: { edit: backspaceword },
      keycode: backspace,
      mode: emacs,
      modifier: alt,
    },
    {
      name: delete_one_word_backward,
      event: { edit: backspaceword },
      keycode: char_m,
      mode: emacs,
      modifier: alt,
    },
    {
      name: delete_one_word_forward,
      event: { edit: deleteword },
      keycode: delete,
      mode: emacs,
      modifier: alt,
    },
    {
      name: escape,
      event: { send: esc }, # NOTE: does not appear to work
      keycode: escape,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: help_menu,
      event: { send: menu, name: help_menu },
      keycode: f1,
      mode: [emacs, vi_insert, vi_normal],
      modifier: none,
    },
    {
      name: history_menu,
      event: { send: menu, name: history_menu },
      keycode: char_r,
      mode: [emacs, vi_insert, vi_normal],
      modifier: control,
    },
    {
      name: lower_case_word,
      event: { edit: lowercaseword },
      keycode: char_l,
      mode: emacs,
      modifier: alt,
    },
    {
      name: move_down,
      event: {
        until: [
          { send: menudown },
          { send: down },
        ],
      },
      keycode: down,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: move_down,
      event: {
        until: [
          { send: menudown },
        ],
      },
      keycode: char_t,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: move_left,
      event: {
        until: [
          { send: menuleft },
          { send: left },
        ],
      },
      keycode: left,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: move_left,
      event: { edit: moveleft },
      keycode: backspace,
      mode: vi_normal,
      modifier: none,
    },
    {
      name: move_left,
      event: {
        until: [
          { send: menuleft },
          { send: left },
        ]
      },
      keycode: char_b,
      mode: emacs,
      modifier: control,
    },
    {
      name: move_one_word_left,
      event: { edit: movewordleft },
      keycode: left,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: move_one_word_left,
      event: { edit: movewordleft },
      keycode: left,
      mode: emacs,
      modifier: alt,
    },
    {
      name: move_one_word_left,
      event: { edit: movewordleft },
      keycode: char_b,
      mode: emacs,
      modifier: alt,
    },
    {
      name: move_one_word_right_or_take_history_hint,
      event: {
        until: [
          { send: historyhintwordcomplete },
          { edit: movewordright },
        ],
      },
      keycode: right,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: move_one_word_right_or_take_history_hint,
      event: {
        until: [
          { send: historyhintwordcomplete},
          { edit: movewordright },
        ],
      },
      keycode: right,
      mode: emacs,
      modifier: alt,
    },
    {
      name: move_one_word_right_or_take_history_hint,
      event: {
        until: [
          { send: historyhintwordcomplete},
          { edit: movewordright },
        ],
      },
      keycode: char_f,
      mode: emacs,
      modifier: alt,
    },
    {
      name: move_right_or_take_history_hint,
      event: {
        until: [
          { send: historyhintcomplete },
          { send: menuright },
          { send: right },
        ],
      },
      keycode: right,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: move_right_or_take_history_hint,
      event: {
        until: [
          { send: historyhintcomplete },
          { send: menuright },
          { send: right },
        ],
      },
      keycode: char_f,
      mode: emacs,
      modifier: control,
    },
    {
      name: move_to_line_end,
      event: { edit: movetolineend },
      keycode: end,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: move_to_line_end_or_take_history_hint,
      event: {
        until: [
          { send: historyhintcomplete },
          { edit: movetolineend },
        ],
      },
      keycode: end,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: move_to_line_end_or_take_history_hint,
      event: {
        until: [
          { send: historyhintcomplete },
          { edit: movetolineend },
        ],
      },
      keycode: char_e,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: move_to_line_start,
      event: { edit: movetolinestart },
      keycode: home,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: move_to_line_start,
      event: { edit: movetolinestart },
      keycode: char_a,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: move_to_line_start,
      event: { edit: movetolinestart },
      keycode: home,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: move_up,
      event: {
        until: [
          { send: menuup },
          { send: up },
        ],
      },
      keycode: up,
      mode: [emacs, vi_normal, vi_insert],
      modifier: none,
    },
    {
      name: move_up,
      event: {
        until: [
          { send: menuup },
        ],
      },
      keycode: char_p,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: newline_or_run_command,
      event: { send: enter },
      keycode: enter,
      mode: emacs,
      modifier: none,
    },
    {
      name: next_page_menu,
      event: { send: menupagenext },
      keycode: char_x,
      mode: emacs,
      modifier: control,
    },
    {
      name: open_command_editor,
      event: { send: openeditor },
      keycode: char_o,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: paste_before,
      event: { edit: pastecutbufferbefore },
      keycode: char_y,
      mode: emacs,
      modifier: control,
    },
    {
      name: quit_shell,
      event: { send: ctrld },
      keycode: char_d,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: redo_change,
      event: { edit: redo },
      keycode: char_g,
      mode: emacs,
      modifier: control,
    },
    {
      name: search_history,
      event: { send: searchhistory },
      keycode: char_r,
      mode: [emacs, vi_normal, vi_insert],
      modifier: control,
    },
    {
      name: swap_graphemes,
      event: { edit: swapgraphemes },
      keycode: char_t,
      mode: emacs,
      modifier: control,
    },
    {
      name: undo_change,
      event: { edit: undo },
      keycode: char_z,
      mode: emacs,
      modifier: control,
    },
    {
      name: undo_or_previous_page_menu,
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
      name: upper_case_word,
      event: { edit: uppercaseword },
      keycode: char_u,
      mode: emacs,
      modifier: alt,
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
  ],

  # `true` or `false` to enable or disable right prompt to be rendered on last
  # line of the prompt.
  render_right_prompt_on_last_line: false,
  rm: {
    # Always act as if `--trash` was given. Can be overridden
    # with `--permanent`
    always_trash: true,
  },

  # Enables terminal shell integration. Off by default, as some terminals have
  # issues with this.
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
overlay use completions
overlay use modules/dotenv
overlay use modules/helpers
overlay use --prefix modules/math
overlay use modules/operations
overlay use scripts/ssh.nu

# Should be last overlay. If additional overlays used in `login.nu`, then add
# `overlay use session` after them
overlay new session
