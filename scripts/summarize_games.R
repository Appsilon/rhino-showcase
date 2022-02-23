game_data <- data %>%
  dplyr::filter(ISO3c != unmapped_countries) %>%
  group_by(Year, City, Game) %>%
  summarize(
    n_athletes = n_distinct(Athlete),
    n_events = n_distinct(Event),
    n_countries = n_distinct(Country)
  ) %>%
  ungroup() %>%
  bind_rows(., data %>%
    summarize(
      n_athletes = n_distinct(Athlete),
      n_events = n_distinct(Event),
      n_countries = n_distinct(ISO3c)
    ) %>%
    mutate(
      Year = 0,
      Game = "Over all Olympic history"
    ))

timeline_data <- game_data %>%
  dplyr::filter(Year != 0) %>%
  mutate(
    text_pos = rep(c("bottom center", "top center"), length.out = n()),
    content = case_when(
      text_pos == "top center" ~ glue("{City}<br><b>{Year}</b>"),
      TRUE ~ glue("<b>{Year}</b><br>{City}")
    ),
    color = "#d9d3ce"
  )

write_fst(game_data, path = paste0(save_path, "game_data.fst"))
write_fst(timeline_data, path = paste0(save_path, "timeline_data.fst"))
