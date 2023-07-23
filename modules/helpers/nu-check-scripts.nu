export def main [] {
  let failed_scripts = (
    $env.NU_LIB_DIRS
      | par-each { |it|
          cd $it

          glob **/*.nu | par-each { |it|
            try {
              cd ($it | path dirname)

              nu-check --all --debug $it | null
            } catch {
              $it
            }
          }
        }
      | flatten
  )

  if ($failed_scripts | is-empty) {
    return
  }

  print 'Failed scripts:'

  $failed_scripts | sort
}
