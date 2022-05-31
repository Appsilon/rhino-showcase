box::use(
  odbc,
  RSQLite,
  shiny,
  shiny.stats,
)

#' @export
db_credentials <- list(
  DB_DRIVER = "SQLite",
  DB_NAME = "stats.sqlite"
)

#' @export
user <- function(session = shiny$getDefaultReactiveDomain()) {
  "test"
}

#' @export
connection <- function(session = shiny$getDefaultReactiveDomain()) {
  session$userData$stats_connection
}

#' @export
initialize <- function(session = shiny$getDefaultReactiveDomain()) {
  connection <-
    odbc$dbConnect(RSQLite$SQLite(), dbname = db_credentials$DB_NAME) |>
    shiny.stats$initialize_connection(username = user(session))
  shiny.stats$log_login(connection)
  shiny.stats$log_logout(connection)
  shiny$observe(shiny.stats$log_browser_version(session$input, connection))
  session$userData$stats_connection <- connection
}
