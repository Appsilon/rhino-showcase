box::use(
  odbc,
  RSQLite,
  shiny.stats,
)

get_user <- function() "test"

#' @export
connect <- function() {
  odbc$dbConnect(RSQLite$SQLite(), dbname = "stats.sqlite") |>
    shiny.stats$initialize_connection(username = get_user())
}
