# Note: if the map_url below fails to work, you can also get the dataset
# manually from the link below:
# https://hub.arcgis.com/datasets/esri::world-countries-generalized/explore?location=-0.062553%2C0.000000%2C2.00

map_url <-
  "https://opendata.arcgis.com/api/v3/datasets/2b93b06dc0dc4e809d3c8db5cb96ba69_0/downloads/data?format=shp&spatialRefId=4326&where=1%3D1"

file <- paste0("./scripts/raw_data/", "world_map_data", ".zip")

if (!file.exists(file)) download.file(map_url, file)

tmp <- tempdir()
unzip(file, exdir = tmp)

countries <- sf::st_read(
  dsn = tmp
)

data <- fst::read_fst(path = "./app/data/olympics_data.fst")

countries <- countries |>
  dplyr::mutate(ISO3c = countrycode::countrycode(
    ISO,
    origin = "iso2c",
    destination = "iso3c"
  ))

map_data <-
  countries |>
  dplyr::mutate(
    centroid_LON = sf::st_coordinates(sf::st_centroid(geometry))[, 1],
    centroid_LAT = sf::st_coordinates(sf::st_centroid(geometry))[, 2]
  ) |>
  dplyr::select(c(COUNTRY, ISO3c, geometry, centroid_LON, centroid_LAT)) |>
  dplyr::filter(ISO3c %in% unique(data$ISO3c))

sf::st_write(map_data, dsn = "./app/data/map_data.shp")
