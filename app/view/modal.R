box::use(
  shiny, shiny[tags],
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$actionButton(ns("hello"), "Say Hello")
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    shiny$observeEvent(input$hello, {
      shiny$showModal(hello_modal)
    })
  })
}

hello_modal <- shiny$modalDialog(
  title = "Hello!",
  "Nice to meet you."
)
