box::use(
  shiny[...],
  shiny.semantic[
    button,
    card,
    cards,
    header,
    icon,
    segment,
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    tags$i(
      id = ns("about_button"),
      class = "info circle icon large"
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}