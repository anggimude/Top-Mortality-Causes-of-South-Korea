#### Preamble ####
# Purpose: Cleans the raw plane data so that it can be used for modelling
# Author: Hyuk Jang
# Date: today
# Contact: hyuk.jang@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Clean data ####

# clean year 2000 data
clean_korea_2000 <- korea_2000 |>
  select(c(Year, Cause, Deaths, `Death rate per 100 000 population`))|>
  arrange(desc(Deaths))|>
  mutate(
    Deaths = as.integer(Deaths),
    Death_rate = as.integer(`Death rate per 100 000 population`),
    Ranking = rank(desc(Deaths))
    )|>
  select(-`Death rate per 100 000 population`)|>
  filter(Ranking <= 10)

# clean year 2010 data
clean_korea_2010 <- korea_2010 |>
  select(c(Year, Cause, Deaths, `Death rate per 100 000 population`))|>
  arrange(desc(Deaths))|>
  mutate(
    Deaths = as.integer(Deaths),
    Death_rate = as.integer(`Death rate per 100 000 population`),
    Ranking = rank(desc(Deaths))
  )|>
  select(-`Death rate per 100 000 population`)|>
  filter(Ranking <= 10)

# clean 2015 data
clean_korea_2015 <- korea_2015 |>
  select(c(Year, Cause, Deaths, `Death rate per 100 000 population`))|>
  arrange(desc(Deaths))|>
  mutate(
    Deaths = as.integer(Deaths),
    Death_rate = as.integer(`Death rate per 100 000 population`),
    Ranking = rank(desc(Deaths))
  )|>
  select(-`Death rate per 100 000 population`)|>
  filter(Ranking <= 10)

# clean 2019 data
clean_korea_2019 <- korea_2019 |>
  select(c(Year, Cause, Deaths, `Death rate per 100 000 population`))|>
  arrange(desc(Deaths))|>
  mutate(
    Deaths = as.integer(Deaths),
    Death_rate = as.integer(`Death rate per 100 000 population`),
    Ranking = rank(desc(Deaths))
  )|>
  select(-`Death rate per 100 000 population`)|>
  filter(Ranking <= 10)

# Create a merged table
common_columns <- Reduce(intersect, lapply(list(names(clean_korea_2000), names(clean_korea_2010), names(clean_korea_2015), names(clean_korea_2019)), as.character))

# Remove 'dataset' from common columns
common_columns <- setdiff(common_columns, 'dataset')

# Subset data frames to include only common columns
clean_korea_2000 <- clean_korea_2000[, c(common_columns)]
clean_korea_2010 <- clean_korea_2010[, c(common_columns)]
clean_korea_2015 <- clean_korea_2015[, c(common_columns)]
clean_korea_2019 <- clean_korea_2019[, c(common_columns)]

# Combine data frames without 'dataset' column
all_data <- rbind(
  clean_korea_2000[1:10, ],
  clean_korea_2010[1:10, ],
  clean_korea_2015[1:10, ],
  clean_korea_2019[1:10, ]
)

common_all_data <- all_data |>
  group_by(Cause) |>
  filter(n() > 1)|>
  select(-Ranking, -Death_rate)

intersect_all_data <- all_data |>
  group_by(Cause) |>
  filter(n() > 3)|>
  select(-Ranking, -Death_rate)

write_csv(all_data, "~/Top Mortality Causes South Korea/data/cleaned_data/all_data.csv")
write_csv(intersect_all_data, "~/Top Mortality Causes South Korea/data/cleaned_data/intersect_all_data.csv")

