box::use(
  shiny[...],
  shiny.semantic[
    button,
    card,
    cards,
    create_modal,
    header,
    icon,
    modal,
    segment,
    show_modal,
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
    observeEvent(input$about_button, {
      print("I am here")
      create_modal(
        modal(
          id = "about_modal",
          title = "About Section",
          header = "About Section",
          content = div(
            h1("This modal will close after 3 sec.")
          ),
          footer = "Developed with  💕 by Appsilon"
        )
      )
    })
  })
}