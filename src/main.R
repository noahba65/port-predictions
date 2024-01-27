library(tidyverse)
library(prophet)
library(RSocrata)
library(forecast)

port_data_url <- "https://data.lacity.org/resource/m54y-rpri.json"

source("src/import.R")

source("src/cleaning.R")