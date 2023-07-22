export-env {
  let hook = {
    if not ('.envrc' | path exists) {
      return
    }

    try {
      let direnv = (^direnv export json | from json)

      if ($direnv | is-empty) {
        return
      }

      $direnv | load-env
    }
  }
  let config_direnv = {
    hooks: {
      pre_prompt: ($env.config.hooks.pre_prompt | append $hook)
    }
  }

  let-env config = ($env.config | merge $config_direnv)
}
