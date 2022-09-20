export alias pg-run = pg-start
export alias pg-start = (
  docker run --rm -p `5432:5432` -e POSTGRES_PASSWORD="ppmdevdb" --name `demo-postgres` `postgres:13.1`
)
