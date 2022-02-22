box::use(
  shiny[moduleServer, NS, reactive, div, is.reactive, observeEvent, eventReactive],
  leaflet[...],
  shiny.semantic[card, segment],
  htmlwidgets[onRender, JS],
  dplyr[filter, select, left_join, case_when, mutate],
  purrr[map],
  magrittr[`%>%`],
  glue[glue]
)

box::use(
  modules/update_map[...]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  leafletOutput(ns("map"), width = "99%", height = "100%")
}

#' @export
server <- function(id, map_data, medal_data, event_podium, year) {
  stopifnot(is.data.frame(medal_data))
  stopifnot(is.data.frame(map_data))
  stopifnot(is.list(event_podium))
  stopifnot(is.reactive(year))

  moduleServer(id, function(input, output, session) {
    id_data <- medal_data %>%
      dplyr::filter(Year == 0) %>%
      dplyr::select(Country, ISO3c)

    output$map <- renderLeaflet({
      leaflet(
        data = map_data,
        options = leafletOptions(
          preferCanvas = TRUE,
          zoomControl = FALSE,
          minZoom = 2,
          attributionControl = TRUE
        )
      ) %>%
        setView(lng = 10, lat = 25, zoom = 2) %>%
        addProviderTiles(providers$CartoDB.VoyagerNoLabels,
          options = providerTileOptions(
            updateWhenZooming = FALSE,
            updateWhenIdle = FALSE
          )
        ) %>%
        addPolygons(
          layerId = ~ISO3c,
          color = "black",
          fillColor = "#e2e2e2",
          dashArray = "3",
          weight = 1,
          group = "Medal Count",
          popup = "",
          smoothFactor = 1,
          fillOpacity = 1,
          highlightOptions = highlightOptions(
            color = "white",
            weight = 2,
            dashArray = "",
            fillOpacity = 0.9,
            bringToFront = FALSE
          )
        ) %>%
        addEasyButton(
          easyButton(
            position = "topleft",
            icon = "ion-arrow-shrink",
            title = "Reset location",
            onClick = JS("function(btn, map) {map.setView(map._initialCenter, map._initialZoom);}")
          )
        ) %>%
        onRender(
          JS("function(el, x) {var map = this; map._initialCenter = map.getCenter(); map._initialZoom = map.getZoom();}")
        ) %>%
        addLegend("bottomleft",
          layerId = "legend_np",
          colors = "#e2e2e2",
          labels = "Non-participating"
        ) %>%
        addLayersControl(
          overlayGroups = c("Medal Count", "Event Medals"),
          options = layersControlOptions(collapsed = FALSE)
        )
    })

    observeEvent(year(), {
      update_polygon_colors("map", id_data, medal_data, year(), map_data)
    })
    marker_data <- eventReactive(event_podium$podium_data(), {
      event_podium$podium_data() %>%
        mutate(popup_base = glue("<strong>{Country}</strong><br>{Sport} - {Event_short}<br>"),
               popup = case_when(
                 Year != 0 ~ glue("{popup_base}{Game}"),
          TRUE ~ glue("{popup_base}Rank <b>#{-1*(y)+ 4}</b> - Most gold medals won overall")
        )) %>%
        left_join(., map_data %>% dplyr::select(ISO3c, cnt_LON, cnt_LAT),
                  by = "ISO3c"
        )
    })
    observeEvent(marker_data(), ignoreInit = TRUE, {
      update_markers("map", marker_data())
    })
    observeEvent(event_podium$selected_podium_flag(), {
      marker_data() %>%
        dplyr::filter(x == event_podium$selected_podium_flag()) %>%
        zoom_in_country(., map_id = "map", zoom = 4)
    })
  })
}
