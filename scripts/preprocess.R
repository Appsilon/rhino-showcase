raw_data <- fread(file = "./scripts/raw_data/athlete_events.csv", encoding = "UTF-8")

# Preprocessing steps:
#  - Just summer olympics.
#  - Add ISO3c for matching with country map data (+ Country name for display).
#  - Remove records without ISO3c (non-mappable).
#  - Collapse team-sports events medals to just one row with Name = "National Team".
#  - Collapse team-sports events without medals to just one row with Name = "Represented".
#  - Keep relevant columns.

data <-
  raw_data %>%
  dplyr::filter(Season == "Summer") %>%
  mutate(
    ISO2c   = countrycode(NOC, origin = "ioc", destination = "iso2c", warn = FALSE),
    ISO3c   = countrycode(NOC, origin = "ioc", destination = "iso3c", warn = FALSE),
    Country = countrycode(NOC, origin = "ioc", destination = "country.name.en", warn = FALSE)
  ) %>%
  dplyr::filter(!is.na(ISO3c), Year != 1906) %>%
  group_by(Year, Event, ISO3c, Medal) %>%
  mutate(N = sum(!is.na(Medal))) %>%
  slice_head() %>%
  ungroup() %>%
  mutate(
    Athlete = case_when(
      N > 1 ~ "National Team",
      N == 0 ~ "Represented",
      TRUE ~ Name
    ),
    City = case_when(
      Year == 1956 ~ "Melbourne",
      TRUE ~ City
    ),
    Event_short = trimws(str_remove(Event, Sport)),
    Game = paste(City, Year)
  ) %>%
  dplyr::select(
    Game, Year, City, Athlete, Country, NOC,
    ISO3c, ISO2c, Sport, Event, Event_short, Medal
  )

write_fst(data, path = paste0(save_path, "olympics_data.fst"))
