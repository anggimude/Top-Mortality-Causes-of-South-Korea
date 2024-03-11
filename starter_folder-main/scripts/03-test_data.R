#### Preamble ####
# Purpose: Tests to check if the cleaned data returns TRUE for given conditions
# Author: Hyuk Jang
# Date: today
# Contact: hyuk.jang@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)


#### Test data ####

# Tests if death column is integers
intersect_all_data$Deaths |> class() == "integer"
# Tests if all causes appear four times
all(table(intersect_all_data$Cause) == 4)
# Tests if there are four different years
length(unique(intersect_all_data$Year)) == 4
# Tests if we the data set contains the top 10 mortality causes
all(all_data$Ranking <= 10)
# Tests if number of deaths is larger than 0
all(all_data$Deaths > 0)
# Tests if death rate is larger than 0
all(all_data$Death_rate > 0)
# Tests if number of deaths is in integers
all_data$Deaths |> class() == "integer"
# Tests if death rate is in integers
all_data$Death_rate |> class() == "integer"
# Tests if Ranking is larger or equal to 1
all(all_data$Ranking >= 1)
# Tests if cause is in characters
all(sapply(all_data$Cause, is.character))

