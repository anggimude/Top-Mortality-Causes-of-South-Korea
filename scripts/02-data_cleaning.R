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

# Find causes appearing at least twice
common_all_data <- all_data |>
  group_by(Cause) |>
  filter(n() > 1)|>
  select(-Ranking, -Death_rate)

# Find causes appearing in all 4 years
intersect_all_data <- all_data |>
  group_by(Cause) |>
  filter(n() > 3)|>
  select(-Ranking, -Death_rate)

# select data for comparison for year 2000
selected_2000 <- korea_2000 |>
  filter(
    Cause %in% c("Road injury", "Self-harm")
  )|>
  select(Cause, Deaths)
  
# For 2010
selected_2010 <- korea_2010 |>
  filter(
    Cause %in% c("Road injury", "Self-harm")
  )|>
  select(Cause, Deaths)

# For 2015
selected_2015 <- korea_2015 |>
  filter(
    Cause %in% c("Road injury", "Self-harm")
  )|>
  select(Cause, Deaths)

# For 2019
selected_2019 <- korea_2019 |>
  filter(
    Cause %in% c("Road injury", "Self-harm")
  )|>
  select(Cause, Deaths)

# Merging the comparison data for the 4 years
merged_selected <- bind_rows(
  selected_2000 |> mutate(Year = 2000),
  selected_2010 |> mutate(Year = 2010),
  selected_2015 |> mutate(Year = 2015),
  selected_2019 |> mutate(Year = 2019)
)

# writing and saving the data as csv in analysis data
write_csv(all_data, "~/Top Mortality Causes South Korea/data/analysis_data/all_data.csv")
write_csv(intersect_all_data, "~/Top Mortality Causes South Korea/data/analysis_data/intersect_all_data.csv")
write_csv(merged_selected, "~/Top Mortality Causes South Korea/data/analysis_data/merged_selected.csv")
write_csv(common_all_data, "~/Top Mortality Causes South Korea/data/analysis_data/common_all_data.csv")
