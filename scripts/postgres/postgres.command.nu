export def pg-backup [
  file_prefix: string
] {
  docker exec -t demo-postgres pg_dumpall -c -U postgres
    | save $"($file_prefix)-(date now | into int).sql"
}

export def pg-restore [
  file_prefix: string
] {
  ls $"($file_prefix)-*.sql"
    | par-each { |row|
        $row
          | update modified (
              $row.name
                | parse --regex `(?P<time>\d+)`
                | $in.time.0
                | into datetime
            )
      }
    | sort-by --reverse `modified`
    | open $in.name.0
    | docker exec -i demo-postgres psql -U postgres
}
