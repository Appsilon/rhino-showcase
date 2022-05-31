box::use(
  leaflet,
  shiny, shiny[isolate, tagList, tags],
)
box::use(
  app/logic/data,
  app/logic/shiny[event_reactive_val],
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  tagList(
    shiny$sliderInput(ns("size"), "Data size", min = 1, max = 10, value = 3),
    shiny$actionButton(ns("generate"), "Generate"),
    leaflet$leafletOutput(ns("map"))
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    size <- event_reactive_val(0)
    shiny$observeEvent(input$generate, size(input$size))
    output$map <- leaflet$renderLeaflet({
      data$random_points(size()) |> data$map()
    })
  })
}
