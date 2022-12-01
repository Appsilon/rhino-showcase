box::use(
  shiny[moduleServer, NS, is.reactive, reactive, eventReactive, observeEvent, div],
  shiny.semantic[card],
  plotly[...],
  dplyr[filter, slice_head],
  magrittr[`%>%`]
)

box::use(
  app/r/utils[add_medal_trace, customize_axes, make_flag_data]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  card(
    class = "fluid",
    div(
      class = "content",
      div(class = "header", "Medal Count"),
      div(class = "ui divider"),
      div(class = "description", plotlyOutput(ns("info_plot"), height = "100px"))
    )
  )
}

#' @export
server <- function(id, year, medal_data) {
  stopifnot(is.reactive(year))
  stopifnot(is.data.frame(medal_data))

  moduleServer(id, function(input, output, session) {
    observeEvent(session$clientData, ignoreInit = FALSE, {
      year_medal_data <- medal_data %>%
        dplyr::filter(Year == year()) %>%
        slice_head(n = 5)
      output$info_plot <- renderPlotly({
        plot_ly(
          source = "info_plot",
          type = "bar", orientation = "h"
        ) %>%
          add_medal_trace(., x = year_medal_data$n_bronze, name = "Bronze", color = "#CD7F32") %>%
          add_medal_trace(., x = year_medal_data$n_silver, name = "Silver", color = "#C0C0C0") %>%
          add_medal_trace(., x = year_medal_data$n_gold, name = "Gold", color = "#FFD700") %>%
          customize_axes(.) %>%
          layout(
            margin = list(t = 0, b = 0, l = 50, r = 0),
            yaxis = list(autorange = "reversed"),
            images = make_flag_data(year_medal_data),
            legend = list(title = "", x = 0.9, y = 0),
            barmode = "stack",
            bargap = 0.6
          )
      })
    })

    observeEvent(year(), ignoreInit = TRUE, {
      year_medal_data <- medal_data %>%
        dplyr::filter(Year == year()) %>%
        slice_head(n = 5)

      plotlyProxy("info_plot", session) %>%
        plotlyProxyInvoke("animate", update_info_plot(year_medal_data))
    })

    reactive(medal_data[event_data("plotly_click", source = "info_plot")$y, ])
  })
}

#' @export
update_info_plot <- function(data) {
  list(
    data = list(
      list(x = data$n_bronze),
      list(x = data$n_silver),
      list(x = data$n_gold)),
    traces = list(1, 2, 3),
    layout = list(
      xaxis = list(
        title = "",
        range = c(0, max(data$n_total))
      ),
      images = make_flag_data(data)
    )
  )
}
