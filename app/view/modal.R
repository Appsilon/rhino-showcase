box::use(
  shiny, shiny[tags],
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  tags$h3(
    shiny$textOutput(ns("message"))
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$message <- shiny$renderText("Modal")
  })
}
