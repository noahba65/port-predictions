port_data_2016_clean <- port_data_2016_raw %>%
  drop_na() %>%
  mutate(
    # Convert month names to date objects (using the 1st of each month in 2016)
    date = as.Date(paste0("2016-", match(Month, month.name), "-01")),
    # Adjust date to the last day of each month
    date = ceiling_date(date, "month") - days(1)
  )  %>%
  select(date, monthly_total_teus)

port_data_2017_clean <- port_data_2017_raw %>%
  drop_na() %>%
  mutate(
    date = as.Date(paste0("2017-", match(Month, month.name), "-01")),
    date = ceiling_date(date, "month") - days(1)
  )  %>%
  select(date, monthly_total_teus)

port_data_2018_clean <- port_data_2018_raw %>%
  drop_na() %>%
  mutate(
    date = as.Date(paste0("2018-", match(Month, month.name), "-01")),
    date = ceiling_date(date, "month") - days(1)
  )  %>%
  select(date, monthly_total_teus)

port_data_2019_clean <- port_data_2019_raw %>%
  drop_na() %>%
  mutate(
    date = as.Date(paste0("2019-", match(Month, month.name), "-01")),
    date = ceiling_date(date, "month") - days(1)
  )  %>%
  select(date, monthly_total_teus)

# Clean  and select dates and monthly_total_teus columns
# Filters out 2009 and 2016 since 2016 is incomplete in this data
# and 2009 was an outlier due to the Great Recession
port_data_clean <- port_data_raw %>%
  mutate(date = ymd(date), monthly_total_teus = as.numeric(monthly_total_teus)) %>%
  select(date, monthly_total_teus) %>%
  
  # Filters out 2009 was an outlier due to the Great Recession
  filter(year(date) != 2009) %>%
  rbind(port_data_2016_clean %>% slice_tail(n = 3)) %>%
  rbind(port_data_2017_clean) %>%
  rbind(port_data_2018_clean) %>% 
  rbind(port_data_2019_clean) %>%
  arrange(date) 


port_train <- port_data_clean %>%
  filter(date <= forecast_cutoff)

port_test <- port_data_clean %>%
  filter(date > forecast_cutoff & date <= (forecast_cutoff + months(12)))
  




