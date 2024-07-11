box::use(
  shiny,
  shiny.semantic[card],
  plotly,
  dplyr[arrange, filter, left_join, pull, first],
  magrittr[`%>%`],
)

box::use(
  app/logic/utils[customize_axes, update_podium_flags, reset_podium_flags, add_podium_bar],
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  card(class = "fluid", shiny$div(
    class = "content",
    shiny$div(class = "header", shiny$textOutput(ns("card_title"))),
    shiny$div(
      class = "description",
      shiny$div(class = "ui shiny$divider"),
      plotly$plotlyOutput(ns("podium"), height = "100")
    ),
    shiny$div(
      class = "meta",
      shiny$div(class = "ui shiny$divider"),
      shiny$HTML("<i>Missing flags correspond to countries that no longer exist.</i>")
    )
  ))
}

#' @export
server <- function(id, events_data, year, event_sport) {
  stopifnot(shiny$is.reactive(year))
  stopifnot(is.list(event_sport))
  stopifnot(is.data.frame(events_data))

  shiny$moduleServer(id, function(input, output, session) {
    flag_pos <- data.frame(
      x = c(3, 2, 1),
      y = c(1, 3, 2),
      Medal = c("Bronze", "Gold", "Silver"),
      color = c("#CD7F32", "#FFD700", "#C0C0C0")
    )
    n_flags <- nrow(flag_pos)
    podium_data <- events_data %>%
      left_join(., flag_pos, by = "Medal")

    output$podium <- plotly$renderPlotly({
      plotly$plot_ly(
        source = "podium",
        type = "bar"
      ) %>%
        add_podium_bar(., flag_pos[2, ]) %>%
        add_podium_bar(., flag_pos[3, ]) %>%
        add_podium_bar(., flag_pos[1, ]) %>%
        customize_axes(.) %>%
        plotly$layout(
          margin = list(t = 0, b = 0, l = 0, r = 0),
          yaxis = list(range = c(0, 6)),
          xaxis = list(range = c(-1, 5)),
          barmode = "overlay",
          title = "",
          images = list(),
          showlegend = FALSE,
          bargap = 0
        )
    })

    event_podium <- shiny$eventReactive(event_sport$event(), {
      podium_data %>%
        filter(Year == year(), Event == event_sport$event()) %>%
        arrange(Medal)
    })

    shiny$observeEvent(event_sport$sport(), {
      reset_podium_flags("podium", session, n_flags)
    })

    shiny$observeEvent(event_podium(), {
      update_podium_flags("podium", session, event_podium())

      output$card_title <- shiny$renderText({
        this_event <- event_podium() %>%
          pull(Event_short) %>%
          first(.)
        ifelse(is.na(this_event), "Select an event", this_event)
      })
    })
    list(
      selected_podium_flag = shiny$reactive(plotly$event_data("plotly_click", source = "podium")$x),
      podium_data = event_podium
    )
  })
}
