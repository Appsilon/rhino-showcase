box::use(
  dplyr[bind_rows, select, filter, mutate, case_when, setdiff, left_join],
  purrr[map_dbl],
  glue[glue],
  magrittr[`%>%`],
  leaflet[
    colorNumeric, popupOptions, leafletProxy, setView, addPolygons, removePopup,
    addLegend, addCircleMarkers, clearGroup, markerClusterOptions, clearPopups
  ]
)

box::use(
  r/leaflet_proxy_helpers[...]
)

#' @export
update_polygon_colors <- function(map_id, id_data, medal_data, year, map_data) {
  stopifnot(is.data.frame(medal_data))
  stopifnot(is.character(map_id))
  stopifnot(is.data.frame(id_data))
  stopifnot(is.numeric(year))

  year_map_data <- medal_data %>%
    dplyr::filter(Year == year) %>%
    mutate(
      popup = case_when(
        n_total > 0 ~ glue("<b>{Country}</b> won {n_total} medals:<br>
                                         {n_gold} gold medals<br>
                                         {n_silver} silver medals<br>
                                         {n_bronze} bronze medals"),
        TRUE ~ glue("<b>{Country}</b><br>did not win any medals")
      ),
      color = colorNumeric("RdPu", domain = n_total)(n_total)
    ) %>%
    dplyr::select(Country, ISO3c, popup, color, n_total)

  non_participating <- setdiff(id_data$ISO3c, year_map_data$ISO3c)

  full_data <- bind_rows(
    year_map_data,
    id_data %>%
      dplyr::filter(ISO3c %in% non_participating) %>%
      mutate(
        color = "#e2e2e2",
        popup = glue("<b>{Country}</b><br>did not participate"),
        n_total = NA
      )
  )

  leafletProxy(map_id, data = full_data) %>%
    removePopup(map_data$ISO3c) %>%
    setView(lng = 10, lat = 25, zoom = 2) %>%
    set_shape_style(
      layer_id = ~ISO3c,
      color = "black",
      fill_color = ~color,
      fill_opacity = 0.9
    ) %>%
    set_shape_popup(
      layer_id = ~ISO3c,
      popup = ~popup,
      options = popupOptions(
        style = list(
          "font-weight" = "normal",
          padding = "2px 5px"
        ),
        textsize = "16px",
        direction = "top"
      )
    ) %>%
    addLegend("bottomleft",
      layerId = "legend",
      pal = colorNumeric("RdPu", domain = year_map_data$n_total),
      values = range(year_map_data$n_total),
      title = "Number of medals"
    )
}

#' @export
update_markers <- function(map_id, marker_data) {
  stopifnot(is.character(map_id))
  stopifnot(is.data.frame(marker_data))

  leafletProxy(map_id, data = marker_data) %>%
    clearPopups() %>%
    clearGroup(group = "Event Medals") %>%
    setView(lng = 10, lat = 25, zoom = 2) %>%
    addCircleMarkers(
      clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = TRUE),
      ~cnt_LON, ~cnt_LAT,
      group = "Event Medals",
      popup = ~popup,
      radius = 10,
      stroke = TRUE, color = "black", weight = 3, opacity = 1,
      fillColor = ~color, fillOpacity = 0.9
    )
}

#' @export
zoom_in_country <- function(data, map_id, zoom) {
  stopifnot(is.character(map_id))
  stopifnot(is.numeric(zoom))
  stopifnot(is.data.frame(data))
  if (nrow(data) == 0) {
    lng <- 10
    lat <- 25
    zoom <- 2
  } else {
    lng <- data$cnt_LON
    lat <- data$cnt_LAT
  }
  leafletProxy(map_id) %>%
    setView(lng = lng, lat = lat, zoom = zoom)
}
