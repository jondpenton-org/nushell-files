## Runs after env.nu

# for more information on themes see
# https://www.nushell.sh/book/coloring_and_theming.html
let default_theme = {
  # color for nushell primitives
  separator: `white`,

  # no fg, no bg, attr none effectively turns this off,
  leading_trailing_space_bg: { attr: `n`, },
  header: `green_bold`,
  empty: `blue`,
  bool: `white`,
  int: `white`,
  filesize: `white`,
  duration: `white`,
  date: `white`,
  range: `white`,
  float: `white`,
  string: `white`,
  nothing: `white`,
  binary: `white`,
  cellpath: `white`,
  row_index: `green_bold`,
  record: `white`,
  list: `white`,
  block: `white`,
  hints: `dark_gray`,

  # shapes are used to change the cli syntax highlighting
  shape_garbage: { fg: `#FFFFFF`, bg: `#FF0000`, attr: `b`, },
  shape_binary: `purple_bold`,
  shape_bool: `light_cyan`,
  shape_int: `purple_bold`,
  shape_float: `purple_bold`,
  shape_range: `yellow_bold`,
  shape_internalcall: `cyan_bold`,
  shape_external: `cyan`,
  shape_externalarg: `green_bold`,
  shape_literal: `blue`,
  shape_operator: `yellow`,
  shape_signature: `green_bold`,
  shape_string: `green`,
  shape_string_interpolation: `cyan_bold`,
  shape_datetime: `cyan_bold`,
  shape_list: `cyan_bold`,
  shape_table: `blue_bold`,
  shape_record: `cyan_bold`,
  shape_block: `blue_bold`,
  shape_filepath: `cyan`,
  shape_globpattern: `cyan_bold`,
  shape_variable: `purple`,
  shape_flag: `blue_bold`,
  shape_custom: `green`,
  shape_nothing: `light_cyan`
}

# The default config record. This is where much of your global configuration
# is setup.
let-env config = {
  cd: {
    abbreviations: true, # allows `cd s/o/f` to expand to `cd some/other/folder`
  },
  completions: {
    algorithm: `fuzzy`, # prefix or fuzzy
    case_sensitive: false, # set to true to enable case-sensitive completions
    external: {
      completer: { |spans|
        if (which carapace | is-empty | not $in) {
          carapace $spans.0 nushell $spans | from json
        }
      },

      # set to false to prevent nushell looking into $env.PATH to find more
      # suggestions, `false` recommended for WSL users as this look up my be
      # very slow
      enable: true,

      # setting it lower can improve completion performance at the cost of
      # omitting some options
      max_results: 100,
    },
    partial: true, # set this to false to prevent partial filling of the prompt

    # set this to false to prevent auto-selecting completions when only
    # one remains
    quick: true,
  },
  cursor_shape: {
    emacs: `block`, # block, underscore, line (line is the default)
    vi_insert: `block`, # block, underscore, line (block is the default)
    vi_normal: `underscore`, # block, underscore, line  (underscore is the default)
  },
  filesize: {
    # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
    format: `auto`,

    # true => KB, MB, GB (ISO standard),
    # false => KiB, MiB, GiB (Windows standard)
    metric: true,
  },
  history: {
    file_format: `plaintext`, # "sqlite" or "plaintext"
    max_size: 10000, # Session has to be reloaded for this to take effect

    # Enable to share history between multiple sessions, else you have to close
    # the session to write history to file
    sync_on_enter: true,
  },
  ls: {
    # enable or disable clickable links. Your terminal has to support links.
    clickable_links: true,

    # use the LS_COLORS environment variable to colorize output
    use_ls_colors: true,
  },
  rm: {
    # always act as if `-t` was given. Can be overridden with `-p`
    always_trash: true,
  },
  table: {
    # "always" show indexes, "never" show indexes, "auto" = show indexes when a
    # table has "index" column
    index_mode: `always`,
    mode: `compact`, # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    trim: {
      methodology: `wrapping`, # wrapping or truncating
      truncating_suffix: `...`, # A suffix used by the 'truncating' methodology
      wrapping_try_keep_words: true, # A strategy used by the 'wrapping' methodology
    },
  },
  color_config: $default_theme,
  use_grid_icons: true,
  footer_mode: `20`, # always, never, number_of_rows, auto
  float_precision: 2,
  # buffer_editor: `emacs` # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  use_ansi_coloring: true,
  edit_mode: emacs, # emacs, vi
  shell_integration: true, # enables terminal markers and a workaround to arrow keys stop working issue
  show_banner: false, # true or false to enable or disable the banner

  hooks: {
    pre_prompt: [
      { ||
        if (which direnv | is-empty) or ('.envrc' | path exists | not $in) {
          return
        }

        mut direnv = (direnv export json | from json)

        if ($direnv | is-empty) {
          return
        }

        match ($direnv.PATH? | describe) {
          `string` => {
            $direnv.PATH = (
              do $env.ENV_CONVERSIONS.PATH.from_string $direnv.PATH | uniq
            )
          }
        }

        $direnv | load-env
      },
    ],
  },
  menus: [
    # Configuration for default nushell menus
    # Note the lack of souce parameter
    {
      name: `completion_menu`,
      only_buffer_difference: false,
      marker: `| `,
      type: {
        layout: `columnar`,
        columns: 4,
        col_width: 20, # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2
      },
      style: {
        text: `green`,
        selected_text: `green_reverse`,
        description_text: `yellow`
      }
    },
    {
      name: `history_menu`,
      only_buffer_difference: true,
      marker: `? `,
      type: {
        layout: `list`,
        page_size: 10
      },
      style: {
        text: `green`
        selected_text: `green_reverse`,
        description_text: `yellow`
      }
    },
    {
      name: `help_menu`,
      only_buffer_difference: true,
      marker: `? `,
      type: {
        layout: `description`,
        columns: 4,
        col_width: 20, # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2,
        selection_rows: 4,
        description_rows: 10
      },
      style: {
        text: `green`,
        selected_text: `green_reverse`,
        description_text: `yellow`
      }
    }
    # Example of extra menus created using a nushell source
    # Use the source field to create a list of records that populates
    # the menu
    {
      name: `commands_menu`,
      only_buffer_difference: false,
      marker: `# `,
      type: {
        layout: `columnar`,
        columns: 4,
        col_width: 20,
        col_padding: 2
      },
      style: {
        text: `green`,
        selected_text: `green_reverse`,
        description_text: `yellow`
      },
      source: { |buffer, position|
        $nu.scope.commands
          | where command =~ $buffer
          | each { ||
              select command usage | rename value description
            }
      }
    },
    {
      name: `vars_menu`,
      only_buffer_difference: true,
      marker: `# `,
      type: {
        layout: `list`,
        page_size: 10
      },
      style: {
        text: `green`,
        selected_text: `green_reverse`,
        description_text: `yellow`
      },
      source: { |buffer, position|
        $nu.scope.vars
          | where name =~ $buffer
          | sort-by name
          | each { ||
              select name type | rename value description
            }
      }
    },
    {
      name: `commands_with_description`,
      only_buffer_difference: true,
      marker: `# `,
      type: {
        layout: `description`,
        columns: 4,
        col_width: 20,
        col_padding: 2,
        selection_rows: 4,
        description_rows: 10
      },
      style: {
        text: `green`,
        selected_text: `green_reverse`,
        description_text: `yellow`
      },
      source: { |buffer, position|
        $nu.scope.commands
          | where command =~ $buffer
          | each { ||
              select command usage | rename value description
            }
      }
    }
  ],
  keybindings: [
    {
      name: `completion_menu`,
      modifier: `none`,
      keycode: `tab`,
      mode: `emacs`, # Options: emacs vi_normal vi_insert
      event: {
        until: [
          { send: `menu`, name: `completion_menu` },
          { send: `menunext` }
        ]
      }
    },
    {
      name: `completion_previous`,
      modifier: `shift`,
      keycode: `backtab`,

      # Note: You can add the same keybinding to all modes by using a list
      mode: [`emacs`, `vi_normal`, `vi_insert`],
      event: { send: `menuprevious` }
    },
    {
      name: `history_menu`,
      modifier: `control`,
      keycode: `char_r`,
      mode: `emacs`,
      event: { send: `menu`, name: `history_menu` }
    },
    {
      name: `next_page`,
      modifier: `control`,
      keycode: `char_x`,
      mode: `emacs`,
      event: { send: `menupagenext` }
    },
    {
      name: `undo_or_previous_page`,
      modifier: `control`,
      keycode: `char_z`,
      mode: `emacs`,
      event: {
        until: [
          { send: `menupageprevious` },
          { edit: `undo` }
        ]
      }
    },
    {
      name: `yank`,
      modifier: `control`,
      keycode: `char_y`,
      mode: `emacs`,
      event: {
        until: [
          { edit: `pastecutbufferafter` }
        ]
      }
    },
    {
      name: `unix-line-discard`,
      modifier: `control`,
      keycode: `char_u`,
      mode: [`emacs`, `vi_normal`, `vi_insert`],
      event: {
        until: [
          { edit: `cutfromlinestart` }
        ]
      }
    },
    {
      name: `kill-line`,
      modifier: `control`,
      keycode: `char_k`,
      mode: [`emacs`, `vi_normal`, `vi_insert`],
      event: {
        until: [
          { edit: `cuttolineend` }
        ]
      }
    },

    # Keybindings used to trigger the user defined menus
    {
      name: `commands_menu`,
      modifier: `control`,
      keycode: `char_t`,
      mode: [`emacs`, `vi_normal`, `vi_insert`],
      event: { send: `menu`, name: `commands_menu` }
    },
    {
      name: `vars_menu`,
      modifier: `alt`,
      keycode: `char_o`,
      mode: [`emacs`, `vi_normal`, `vi_insert`],
      event: { send: `menu`, name: `vars_menu` }
    },
    {
      name: `commands_with_description`,
      modifier: `control`,
      keycode: `char_s`,
      mode: [`emacs`, `vi_normal`, `vi_insert`],
      event: { send: `menu`, name: `commands_with_description` }
    }
    # {
    #   name: commands_with_description
    #   modifier: control
    #   keycode: char_u
    #   mode: [emacs, vi_normal, vi_insert]
    #   event: { send: menu name: commands_with_description }
    # }
  ]
}

## Repository Updates
do {
  cd $env.NU_DIR
  git fetch --quiet

  if 'Your branch is behind' in (git status) {
    echo $'There is an update to the config. Run `nu-config-update` to update.(
      char newline
    )'
  }
}

### Aliases
alias nu-config-update = do { cd $env.NU_DIR; git pull }

## Starship
source ~/.cache/starship/init.nu

## Modules
overlay use dotenv.nu
overlay use git.nu
overlay use helpers.nu
overlay use math.nu
overlay use ssh.nu
overlay new session # Should be last overlay. If additional overlays used in `login.nu`, then add `overlay use session` after them
