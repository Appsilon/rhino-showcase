box::use(
  odbc,
  RSQLite,
  shiny.stats,
)

#' @export
db_credentials <- list(
  DB_NAME = "stats.sqlite",
  DB_DRIVER = "SQLite"
)

#' @export
get_user <- function(session = getDefaultReactiveDomain()) "test"

#' @export
connect <- function() {
  odbc$dbConnect(RSQLite$SQLite(), dbname = db_credentials$DB_NAME) |>
    shiny.stats$initialize_connection(username = get_user())
}
