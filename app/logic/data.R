box::use(
  leaflet,
  stats[runif],
)

#' @export
random_points <- function(size) {
  data.frame(
    latitude = runif(size, -90, 90),
    longitude = runif(size, -180, 180)
  )
}

#' @export
map <- function(points) {
  leaflet$leaflet() |>
    leaflet$addTiles() |>
    leaflet$addMarkers(data = points)
}
