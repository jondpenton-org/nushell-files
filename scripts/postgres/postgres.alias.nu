export alias pg-start = do {
  ^docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD="ppmdevdb" --name demo-postgres postgres:13.1
}

export alias pg-run = pg-start
