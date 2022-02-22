box::use(
  shiny[
    moduleServer, NS, div, tagList, h3, reactive, img,
    eventReactive, observeEvent, reactiveVal
  ],
  shiny.semantic[card, cards],
  plotly[...],
  dplyr[mutate, pull],
  glue[glue],
  magrittr[`%>%`]
)

box::use(
  modules/utils[customize_axes, update_timeline_colors]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  cards(
    class = "one",
    card(
      class = "fluid raised",
      div(
        class = "content",
        div(
          class = "description",
          plotlyOutput(ns("timeline"), height = "18vh", width = "66vw")
        )
      ),
      div(id = ns("overall"), class = "ui bottom attached button", "All Olympic Games")
    )
  )
}

#' @export
server <- function(id, timeline_data) {
  stopifnot(is.data.frame(timeline_data))

  moduleServer(id, function(input, output, session) {
    unselected_color <- "#d9d3ce"
    selected_color <- "#B65FCF"
    border_color <- "#373737"
    border_width <- 3
    marker_size <- 22

    overall_ix <- reactiveVal(TRUE)

    output$timeline <- renderPlotly({
      timeline_plot <- timeline_data %>%
        plot_ly(
          source = "timeline",
          type = "scatter",
          text = ~content,
          textposition = ~text_pos,
          mode = "lines+markers+text"
        ) %>%
        add_trace(
          x = ~Year, y = 0,
          hoverinfo = "none",
          line = list(color = border_color, width = border_width * 1.5),
          marker = list(
            color = ~color,
            size = marker_size,
            line = list(color = border_color, width = border_width)
          ),
          showlegend = FALSE
        ) %>%
        customize_axes() %>%
        layout(
          xaxis = list(automargin = FALSE),
          margin = list(t = 0, b = 0, l = 0, r = 0, pad = 0)
        )
    })

    year_selected <- reactive(event_data("plotly_click", source = "timeline")$x)

    observeEvent(input$overall, {
      overall_ix(TRUE)
      plotlyProxy("timeline", session) %>%
        plotlyProxyInvoke("restyle", update_timeline_colors(
          unselected_color, border_color,
          marker_size, border_width
        ))
    })

    observeEvent(year_selected(), {
      overall_ix(FALSE)
      marker_colors <- timeline_data %>%
        mutate(color = ifelse(Year == year_selected(), selected_color, unselected_color)) %>%
        pull(color)

      plotlyProxy("timeline", session) %>%
        plotlyProxyInvoke("restyle", update_timeline_colors(
          marker_colors, border_color,
          marker_size, border_width
        ))
    })

    reactive({
      ifelse(isTRUE(overall_ix()), 0, year_selected())
    })
  })
}
