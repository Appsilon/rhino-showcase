box::use(
  dplyr[filter],
  magrittr[`%>%`],
  shiny,
  shiny.semantic[card, cards, header, segment],
)

box::use(
  app/view/about_section,
)
#' @export
ui <- function(id) {
  ns <- shiny$NS(id)

  list(
    segment(
      class = "raised title-section",
      shiny$h3(
        style = "text-align: left;",
        shiny$textOutput(ns("info_title"))
      ),
      about_section$ui(ns("about_section"))
    ),
    shiny$div(class = "ui divider"),
    shiny$div(class = "ui container", shiny$htmlOutput(ns("game_info")))
  )
}

#' @export
server <- function(id, year, game_data) {
  stopifnot(shiny$is.reactive(year))
  stopifnot(is.data.frame(game_data))

  shiny$moduleServer(id, function(input, output, session) {

    about_section$server("about_section")

    shiny$observeEvent(year(), {
      this_game_data <- game_data %>%
        filter(Year == year())

      output$info_title <- shiny$renderText(
        ifelse(year() == 0, "All Olympic Games", this_game_data$Game)
      )

      output$game_info <- shiny$renderUI({
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
    shiny$div(
      class = "content",
      shiny$div(class = "tiny header", title),
      shiny$div(class = "ui divider"),
      shiny$div(
        class = "description",
        header(as.character(number), "", icon_name)
      )
    )
  )
}
