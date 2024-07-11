box::use(
  dplyr[distinct, filter, pull],
  magrittr[`%>%`],
  shiny.semantic[update_dropdown_input, vertical_layout],
  shiny[div, h4, is.reactive, moduleServer, NS, observeEvent, reactive],
)

box::use(
  app/logic/utils[make_dropdown],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  vertical_layout(
    rows_heights = c(10, 90),
    h4("Search and select an Olympic sport and event"),
    div(
      class = "ui grid two column",
      make_dropdown(input_id = ns("Sport"), text = "Select a sport", choices = NULL),
      make_dropdown(input_id = ns("Event"), text = "Select an event", choices = NULL)
    )
  )
}

#' @export
server <- function(id, sports_by_year, year) {
  moduleServer(id, function(input, output, session) {
    stopifnot(is.reactive(year))
    stopifnot(is.data.frame(sports_by_year))

    observeEvent(year(), {
      sport_choices <- sports_by_year %>%
        filter(Year == year()) %>%
        distinct(Sport) %>%
        pull(Sport)

      default_sport <- "Select a sport"
      update_dropdown_input(session,
        input_id = "Sport",
        value = default_sport,
        choices = c(default_sport, sport_choices)
      )
    })

    observeEvent(input$Sport, {
      events_by_sport <- sports_by_year %>%
        filter(Year == year()) %>%
        filter(Sport == input$Sport) %>%
        distinct(Event, Event_short)

      default_event <- "Select an event"
      update_dropdown_input(session,
        input_id = "Event",
        value = default_event,
        choices_value = c(default_event, events_by_sport$Event),
        choices = c(default_event, events_by_sport$Event_short)
      )
    })

    list(
      event = reactive(input$Event),
      sport = reactive(input$Sport)
    )
  })
}
