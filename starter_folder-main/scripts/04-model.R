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


cause_of_death_south_korea_poisson <-
  stan_glm(
    Deaths ~ Cause,
    data = intersect_all_data,
    family = poisson(link = "log"),
    seed = 853
  )

cause_of_death_south_korea_neg_binomial <-
  stan_glm(
    Deaths ~ Cause,
    data = intersect_all_data,
    family = neg_binomial_2(link = "log"),
    seed = 853
  )

#### Save model ####
saveRDS(
  cause_of_death_south_korea_poisson,
  file = "starter_folder-main/models/cause_of_death_south_korea_poisson.rds"
)

saveRDS(
  cause_of_death_south_korea_neg_binomial,
  file = "starter_folder-main/models/cause_of_death_south_korea_neg_binomial.rds"
)

coef_short_names <-
  c("Ischaemic heart disease" = "CHD",
    "Liver cancer" = "Liver Cancer",
    "Self-harm" = "Self Harm",
    "Stomach cancer" = "Stomach Cancer",
    "Stroke" = "Stroke",
    "Trachea, bronchus, lung cancers" = "Lung Cancer"
  )

# Extract coefficients from the models
poisson_coefficients <- as.list(coef(cause_of_death_south_korea_poisson))
neg_binomial_coefficients <- as.list(coef(cause_of_death_south_korea_neg_binomial))

poisson_coefficients <- subset(poisson_coefficients$)

# Map the short names to actual names
poisson_coefficients$Cause <- coef_short_names[poisson_coefficients$Cause]
neg_binomial_coefficients$Cause <- coef_short_names[neg_binomial_coefficients$Cause]

# Print or use the modified coefficients data frames
print(poisson_coefficients)
print(neg_binomial_coefficients)








model_list <- list(
  "Poisson" = cause_of_death_south_korea_poisson,
  "Negative binomial" = cause_of_death_south_korea_neg_binomial
)

# Extract the first element from each inner list for Poisson models
poisson_summary_data <- lapply(model_list[[1]], function(poisson_model) {
  poisson_model[[1]]  # Assuming the first element represents the desired information
})

# Extract the first element from each inner list for Negative Binomial models
neg_binomial_summary_data <- lapply(model_list[[2]], function(neg_binomial_model) {
  neg_binomial_model[[1]]  # Assuming the first element represents the desired information
})

# Convert the lists to data frames
poisson_summary_df <- as.data.frame(poisson_summary_data)
neg_binomial_summary_df <- as.data.frame(neg_binomial_summary_data)

# Save the data frames as separate RDS files
saveRDS(poisson_summary_df, "starter_folder-main/models/poisson_summary.rds")
saveRDS(neg_binomial_summary_df, "starter_folder-main/models/neg_binomial_summary.rds")


modelsummary(
  list(
    "Poisson" = cause_of_death_south_korea_poisson,
    "Negative binomial" = cause_of_death_south_korea_neg_binomial
  ),
  coef_map = coef_short_names
)

pp_check(cause_of_death_south_korea_poisson) +
  theme(legend.position = "bottom")

pp_check(cause_of_death_south_korea_neg_binomial) +
  theme(legend.position = "bottom")





