box::use(
  shiny[...],
  shiny.semantic[header, card, cards, segment],
  dplyr[filter],
  magrittr[`%>%`],
)

box::use(
  app/view/about_section,
)
#' @export
ui <- function(id) {
  ns <- NS(id)

  list(
    segment(
      class = "raised title-section",
      h3(
        style = "text-align: left;",
        textOutput(ns("info_title"))
      ),
    about_section$ui(ns("about_section"))
    ),
    div(class = "ui divider"),
    div(class = "ui container", htmlOutput(ns("game_info")))
  )
}

#' @export
server <- function(id, year, game_data) {
  stopifnot(is.reactive(year))
  stopifnot(is.data.frame(game_data))

  moduleServer(id, function(input, output, session) {

    about_section$server("about_section")

    observeEvent(year(), {
      this_game_data <- game_data %>%
        filter(Year == year())

      output$info_title <- renderText(
        ifelse(year() == 0, "All Olympic Games", this_game_data$Game)
      )

      output$game_info <- renderUI({
        cards(
          class = "three",
          make_info_card("Countries", "globe", this_game_data$n_countries),
          make_info_card("Athletes", "running", this_game_data$n_athletes),
          make_info_card("Events", "futbol", this_game_data$n_events)
        )
      })
    })
  })
}

#' @export
make_info_card <- function(title = "", icon_name = "", number = NULL) {
  card(
    class = "ui fluid",
    div(
      class = "content",
      div(class = "tiny header", title),
      div(class = "ui divider"),
      div(
        class = "description",
        header(as.character(number), "", icon_name)
      )
    )
  )
}
