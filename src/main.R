library(tidyverse)
library(prophet)
library(RSocrata)
library(forecast)
library(tesseract)

port_data_url <- "https://data.lacity.org/resource/m54y-rpri.json"
image_base_path <- "~/Documents/GitHub/port-predictions/data/data_images/"
image_2016_file_name <- "port_data_2016.png"
image_2017_file_name <- "port_data_2017.png"

source("src/functions.R")

source("src/import.R")

source("src/cleaning.R")

message("Fitting ARIMA model")
source("src/models/arima.R")

message("Fitting Prophet model")
source("src/models/prophet.R")