box::use(
  leaflet,
)

#' @export
set_shape_style <- function(map, data = leaflet$getMapData(map), layer_id,
                            stroke = NULL, color = NULL, group = NULL,
                            weight = NULL, opacity = NULL,
                            fill = NULL, fill_color = NULL,
                            fill_opacity = NULL, dash_array = NULL,
                            smooth_factor = NULL, no_clip = NULL,
                            options = NULL) {
  options <- c(
    list(layerId = layer_id),
    options,
    leaflet$filterNULL(list(
      stroke = stroke, color = color,
      weight = weight, opacity = opacity,
      fill = fill, fillColor = fill_color,
      fillOpacity = fill_opacity, dashArray = dash_array,
      smoothFactor = smooth_factor, noClip = no_clip
    ))
  )

  options <- leaflet$evalFormula(options, data = data)
  options <- do.call(data.frame, c(options, list(stringsAsFactors = FALSE)))

  layer_id <- options[[1]]
  style <- options[-1]

  leaflet$invokeMethod(map, data, "setStyle", "shape", layer_id, style)
}

#' @export
set_shape_label <- function(map, data = leaflet$getMapData(map), layer_id,
                            label = NULL,
                            options = NULL) {
  options <- c(
    list(layerId = layer_id),
    options,
    leaflet$filterNULL(list(label = label))
  )
  options <- leaflet$evalFormula(options, data = data)
  options <- do.call(data.frame, c(options, list(stringsAsFactors = FALSE)))

  layer_id <- options[[1]]
  label <- options[-1]

  leaflet$invokeMethod(map, data, "setLabel", "shape", layer_id, label)
}

#' @export
set_shape_popup <- function(map, data = leaflet$getMapData(map), layer_id,
                            popup = NULL,
                            options = NULL) {
  options <- c(
    list(layerId = layer_id),
    options,
    leaflet$filterNULL(list(popup = popup))
  )
  options <- leaflet$evalFormula(options, data = data)
  options <- do.call(data.frame, c(options, list(stringsAsFactors = FALSE)))

  layer_id <- options[[1]]
  popup <- options[-1]

  leaflet$invokeMethod(map, data, "setPopup", "shape", layer_id, popup)
}
