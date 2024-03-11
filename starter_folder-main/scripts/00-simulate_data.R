#### Preamble ####
# Purpose: Simulates a tibble of of possible causes of moratlity of South Korea
# Author: Hyuk Jang
# Date: today
# Contact: hyuk.jang@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)


#### Simulate data ####
korea_death_simulation <-
  tibble(
    cause = rep(x = c("Heart", "Stroke", "Cancer", "Tuberclosis"), times = 10),
    year = rep(x = c(2000, 2010, 2015, 2019), times = 10),
    deaths = rnbinom(n = 40, size = 40, prob = 0.5)
  )

korea_death_simulation



