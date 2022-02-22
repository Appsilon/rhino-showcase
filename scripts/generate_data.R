library(magrittr)
library(dplyr)
library(purrr)
library(fst)
library(countrycode)
library(data.table)
library(sf)
library(stringr)
library(base64enc)

save_path <- "./app/data/"

source("./scripts/preprocess.R")
source("./scripts/get_countries_map_data.R")
source("./scripts/summarize_countries.R")
source("./scripts/summarize_events.R")
source("./scripts/summarize_games.R")
