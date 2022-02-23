events_data <- data %>%
  dplyr::filter(!is.na(Medal)) %>%
  distinct(Year, Event, Medal, .keep_all = TRUE) %>%
  dplyr::select(
    Game, Year, ISO3c, ISO2c, Country,
    Sport, Event, Event_short, Medal
  ) %>%
  bind_rows(., data %>%
    dplyr::filter(!is.na(Medal)) %>%
    distinct(Year, Event, .keep_all = TRUE) %>%
    group_by(
      ISO3c, ISO2c, Country,
      Sport, Event, Event_short
    ) %>%
    summarize(n_medals = n()) %>%
    group_by(Event) %>%
    arrange(desc(n_medals), .by_group = TRUE) %>%
    slice_head(n = 3) %>%
    mutate(
      rank = 1:n(),
      Medal = case_when(
        rank == 1 ~ "Gold",
        rank == 2 ~ "Silver",
        TRUE ~ "Bronze"
      ),
      Year = 0, Game = "All"
    ) %>%
    dplyr::select(-c(rank, n_medals))) %>%
  mutate(
    flag = glue("./scripts/flags/{tolower(ISO2c)}.png"),
    flag64 = map_chr(flag, ~ make_flag(.x))
  )

events_data <- events_data %>% dplyr::filter(ISO3c != unmapped_countries)

sports_by_year <- events_data %>%
  distinct(Year, Sport, Event, Event_short)

write_fst(events_data, path = paste0(save_path, "events_data.fst"))
write_fst(sports_by_year, path = paste0(save_path, "sports_by_year.fst"))
