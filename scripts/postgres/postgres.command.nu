export def pg-backup [
  file_prefix: string
] {
  ^docker exec -t demo-postgres pg_dumpall -c -U postgres
    | save $'($file_prefix)-(date now | into int).sql'
}

export def pg-restore [
  file_prefix: string
] {
  ls $'($file_prefix)-*.sql'
    | par-each {
        update modified (
          $in.name
            | parse --regex `(?P<time>\d+)`
            | $in.time.0
            | into datetime
        )
      }
    | sort-by --reverse modified
    | $in.name.0
    | open
    | ^docker exec -i demo-postgres psql -U postgres
}
