box::use(
  checkmate[assert_string, assert_vector],
  waiter[waiter_preloader],
  shiny[img, div, tagList],
  shiny.semantic[dropdown_input],
  plotly[add_trace, add_bars, layout, config, plotlyProxy, plotlyProxyInvoke],
  magrittr[`%>%`],
  dplyr[n, select, mutate],
  purrr[pmap],
)

#' @export
loading_screen <- function(text = "Loading...", bkg_color = "white") {
  assert_string(text, min.chars = 1)
  assert_string(bkg_color, min.chars = 1)

  waiter_preloader(
    html = tagList(
      img(src = "static/logo.png", width = "350"),
      div(class = "load-text", text)
    ),
    color = bkg_color
  )
}

#' @export
make_dropdown <- function(input_id, text, choices) {
  assert_string(input_id, min.chars = 1)
  assert_string(text, min.chars = 1)
  assert_vector(
    x = choices,
    strict = TRUE,
    all.missing = FALSE,
    min.len = 1,
    unique = TRUE,
    null.ok = TRUE
    # `null.ok = FALSE` breaks the app, but there's no docs so it's hard to
    # understand if accepting NULL is desired behaviour or some missing req()
  )

  div(
    class = "column",
    dropdown_input(
      input_id = input_id,
      default_text = text,
      type = "fluid search selection",
      choices = choices
    )
  )
}

#' @export
update_timeline_colors <- function(marker_colors, border_color, marker_size, border_width) {
  list(marker = list(
    color = marker_colors,
    size = marker_size,
    line = list(
      color = border_color,
      width = border_width
    )
  ))
}

#' @export
customize_axes <- function(p) {
  p %>%
    layout(
      autosize = TRUE,
      xaxis = list(visible = FALSE, fixedrange = TRUE),
      yaxis = list(visible = FALSE, fixedrange = TRUE)
    ) %>%
    config(displayModeBar = FALSE)
}

#' @export
add_medal_trace <- function(p, x = 0, name, color) {
  p %>%
    add_trace(
      x = x,
      y = seq(1, length(x)),
      name = name,
      marker = list(color = color)
    )
}

#' @export
add_podium_bar <- function(p, data, y_offset = 1.5) {
  p %>%
    add_bars(
      x = data$x, y = data$y + y_offset,
      name = data$Medal,
      text = "",
      hoverinfo = "text",
      marker = list(color = "white")
    ) %>%
    add_bars(
      x = data$x, y = data$y,
      hoverinfo = "none",
      marker = list(color = data$color)
    )
}

#' @export
make_flag_data <- function(data) {
  data %>%
    mutate(
      x = 0, xref = "x",
      y = seq(1, n())
    ) %>%
    select(flag64, x, y) %>%
    pmap(., make_flags)
}

#' @export
make_flags <- function(flag64, x = 0, y = 0,
                       xref = "paper", yref = "y",
                       xanchor = "right", yanchor = "middle",
                       sizex = 0.65, sizey = 0.65) {
  list(
    source = flag64,
    layer = "above",
    xref = xref, x = x, xanchor = xanchor, sizex = sizex,
    yref = yref, y = y, yanchor = yanchor, sizey = sizey,
    opacity = 1
  )
}

#' @export
update_podium_flags <- function(plot_id, session, data) {
  flag_data <- data %>%
    select(flag64, x, y) %>%
    mutate(
      xref = "x", sizex = 1.2, xanchor = "center",
      yref = "y", sizey = 1, yanchor = "bottom", y = y + 0.5
    )
  plotlyProxy(plot_id, session) %>%
    plotlyProxyInvoke("animate",
                      layout = list(
                        images = pmap(flag_data, make_flags)),
                      traces = as.list(seq(1, 6)),
                      data = list(
                        list(text = data$Country[data$x == 2]), list(),
                        list(text = data$Country[data$x == 1]), list(),
                        list(text = data$Country[data$x == 3]), list())
    )
}

#' @export
reset_podium_flags <- function(plot_id, session, n_flags) {
  plotlyProxy(plot_id, session) %>%
    plotlyProxyInvoke("animate", layout = list(images = as.list(rep(NA, n_flags * 2))))
}
