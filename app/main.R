box::use(
  shiny,
  shiny.stats,
)
box::use(
  app/logic/stats,
  app/view[map, modal],
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$bootstrapPage(
    map$ui(ns("map")),
    modal$ui(ns("modal"))
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    map$server("map")
    modal$server("modal")
    stats_connection <- stats$connect()
    shiny.stats$log_login(stats_connection)
    shiny.stats$log_logout(stats_connection)
  })
}
