#### Preamble ####
# Purpose: Downloads and saves data of death cause and rate of South Korea
# Author: Hyuk Jang
# Date: today
# Contact: hyuk.jang@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(readr)

#### Save data ####
# Saves the data of mortality of South Korea in csv format
korea_2000 <- read_csv("~/Top Mortality Causes South Korea/data/raw_data/korea2000.csv")
korea_2010 <- read_csv("~/Top Mortality Causes South Korea/data/raw_data/korea2010.csv")
korea_2015 <- read_csv("~/Top Mortality Causes South Korea/data/raw_data/korea2015.csv")
korea_2019 <- read_csv("~/Top Mortality Causes South Korea/data/raw_data/korea2019.csv")
