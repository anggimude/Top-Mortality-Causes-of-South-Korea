#### Preamble ####
# Purpose: Models a negative binomial distribution of the cleaned data of the 4 years
# Author: Hyuk Jang
# Date: today
# Contact: hyuk.jang@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(ggplot2)
library(modelsummary)
library(bayesplot)
library(parameters)
library(broom)
library(kableExtra)
library(gt)
library(broom.mixed)


# Create model of common causes of death that appear twice or more
common_all_data |>
  ggplot(aes(x = Year, y = Deaths, color = Cause)) +
  geom_line() +
  ggtitle("Less Common Mortality Causes") +
  xlab("Year") +
  ylab("Annual Number of Deaths in South Korea") +
  theme_minimal() +
  scale_x_continuous(breaks = unique(intersect_all_data$Year)) +
  theme_minimal()

# Create model of common causes of death that appear in all four years
intersect_all_data|>
  ggplot(aes(x = Year, y = Deaths, color = Cause)) +
  geom_line() +
  ggtitle("Common Mortality Causes") +
  xlab("Year") +
  ylab("Annual Number of Deaths in South Korea") +
  theme_minimal() +
  scale_x_continuous(breaks = unique(intersect_all_data$Year)) +
  theme_minimal()

# Poisson Model
cause_of_death_south_korea_poisson <-
  stan_glm(
    Deaths ~ Cause,
    data = intersect_all_data,
    family = poisson(link = "log"),
    seed = 853
  )

# Negative Model
cause_of_death_south_korea_neg_binomial <-
  stan_glm(
    Deaths ~ Cause,
    data = intersect_all_data,
    family = neg_binomial_2(link = "log"),
    seed = 853
  )

# Mapping Coefficient Names
coef_short_names <-
  c("(Intercept)" = "Intercept",
    "CauseLiver cancer" = "Liver Cancer",
    "CauseSelf-harm" = "Self Harm",
    "CauseStomach cancer" = "Stomach Cancer",
    "CauseStroke" = "Stroke",
    "CauseTrachea, bronchus, lung cancers" = "Trachea, Bronchus, Lung Cancer"
  )

# Poisson Model summary
poisson_model_summary <- modelsummary(
  list(
    "Poisson" = cause_of_death_south_korea_poisson
  ),
  coef_map = coef_short_names
)

# Negative binomial summary
neg_bin_model_summary <- modelsummary(
  list(
    "Negative Binomial" = cause_of_death_south_korea_neg_binomial
  ),
  coef_map = coef_short_names
)

#### Save model ####
saveRDS(
  cause_of_death_south_korea_poisson,
  file = "~/Top Mortality Causes South Korea/models/cause_of_death_south_korea_poisson.rds"
)

saveRDS(
  cause_of_death_south_korea_neg_binomial,
  file = "~/Top Mortality Causes South Korea/models/cause_of_death_south_korea_neg_binomial.rds"
)

saveRDS(
  poisson_model_summary,
  file = "~/Top Mortality Causes South Korea/models/poisson_model_summary.rds"
)

saveRDS(
  neg_bin_model_summary,
  file = "~/Top Mortality Causes South Korea/models/neg_bin_model_summary.rds"
)






