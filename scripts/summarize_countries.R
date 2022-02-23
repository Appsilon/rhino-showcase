make_flag <- function(path) {
  paste("data:image/png;base64",
    base64encode(
      readBin(path, "raw", file.info(path)[1, "size"]), "txt"
    ),
    sep = ","
  )
}

medal_data <- data %>%
  group_by(Year, ISO3c, ISO2c, Country) %>%
  summarize(
    n_gold = sum(Medal == "Gold", na.rm = TRUE),
    n_silver = sum(Medal == "Silver", na.rm = TRUE),
    n_bronze = sum(Medal == "Bronze", na.rm = TRUE),
    n_total = n_gold + n_silver + n_bronze
  ) %>%
  group_by(Year) %>%
  arrange(desc(n_total), .by_group = TRUE) %>%
  ungroup() %>%
  bind_rows(., data %>% group_by(ISO3c, ISO2c, Country) %>%
    summarize(
      n_gold = sum(Medal == "Gold", na.rm = TRUE),
      n_silver = sum(Medal == "Silver", na.rm = TRUE),
      n_bronze = sum(Medal == "Bronze", na.rm = TRUE),
      n_total = n_gold + n_silver + n_bronze
    ) %>%
    ungroup() %>%
    arrange(desc(n_total)) %>%
    mutate(Year = 0)) %>%
  mutate(
    flag = glue("./scripts/flags/{tolower(ISO2c)}.png"),
    flag64 = map_chr(flag, ~ make_flag(.x))
  )

unmapped_countries <- anti_join(medal_data %>%
  dplyr::select(-flag64) %>%
  dplyr::filter(Year == 0),
map_data,
by = "ISO3c"
) %>%
  pull(ISO3c)

medal_data <- medal_data %>% dplyr::filter(ISO3c != unmapped_countries)

write_fst(medal_data, path = paste0(save_path, "medal_data.fst"))
