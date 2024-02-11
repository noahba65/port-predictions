library(tidyverse)
library(prophet)
library(RSocrata)
library(forecast)
library(tesseract)

port_data_url <- "https://data.lacity.org/resource/m54y-rpri.json"
image_base_path <- "~/Documents/GitHub/port-predictions/data/data_images/"
port_data_2016 <- "port_data_2016.png"
port_data_2017 <- "port_data_2017.png"
port_data_2018 <- "port_data_2018.png"
port_data_2019 <- "port_data_2019.png"

forecast_cutoff <- as.Date("2019-01-30")

source("src/functions.R")

source("src/import.R")

source("src/cleaning.R")

# message("Fitting ARIMA model")
# source("src/models/arima.R")

message("Fitting Prophet model")
source("src/models/prophet.R")