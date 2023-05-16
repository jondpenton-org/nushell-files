export def pg-backup [
  file_prefix: string
] {
  ^docker exec -t demo-postgres pg_dumpall -c -U postgres
    | save $"($file_prefix)-(date now | into int).sql"
}

export def pg-restore [
  file_prefix: string
] {
  ls $"($file_prefix)-*.sql"
    | update modified (
        $in.name
          | parse --regex `(?P<time>\d+)`
          | $in.0.time
          | into datetime
      )
    | sort-by --reverse modified
    | $in.0.name
    | open
    | ^docker exec -i demo-postgres psql -U postgres
}
