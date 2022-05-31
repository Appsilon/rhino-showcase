box::use(
  shiny[bootstrapPage, moduleServer, NS, renderText, tags, textOutput],
  shiny.stats,
)
box::use(
  app/logic/stats,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    tags$h3(
      textOutput(ns("message"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    stats_connection <- stats$connect()
    shiny.stats$log_login(stats_connection)
    output$message <- renderText("Hello!")
    shiny.stats$log_logout(stats_connection)
  })
}
