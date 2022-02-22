map_url <- paste0(
  "http://www.naturalearthdata.com/http//www.naturalearthdata.com/",
  "download/50m/cultural/ne_50m_admin_0_countries.zip"
)

file <- paste0("./scripts/raw_data/", basename(map_url))

if (!file.exists(file)) download.file(map_url, file)

tmp <- tempdir()
unzip(file, exdir = tmp)

countries <- st_read(
  dsn = tmp,
  layer = strsplit(basename(map_url), split = "\\.")[[1]][1],
  stringsAsFactors = FALSE
)

data <- read_fst(path = "./app/data/olympics_data.fst")

map_data <-
  countries %>%
  mutate(
    ISO3c = case_when(
      ISO_A3 == "-99" ~ ADM0_A3, # replace missing codes
      TRUE ~ ISO_A3
    ),
    centroid_LON = st_coordinates(st_centroid(geometry))[, 1],
    centroid_LAT = st_coordinates(st_centroid(geometry))[, 2]
  ) %>%
  dplyr::select(c(NAME_LONG, ISO3c, geometry, centroid_LON, centroid_LAT)) %>%
  dplyr::filter(ISO3c %in% unique(data$ISO3c))

st_write(map_data, dsn = "./app/data/map_data.shp")
