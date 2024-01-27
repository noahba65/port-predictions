# Clean  and select dates and monthly_total_teus columns
port_data_clean <- port_data_raw %>%
  mutate(date = ymd(date), monthly_total_teus = as.numeric(monthly_total_teus)) %>%
  select(date, monthly_total_teus) %>%
  arrange(date)

# Select training data between 2009 and 2014
port_data_2009_2014 <- port_data_clean %>%
  filter(year(date) < 2015)

# Select evaluation data from the last complete year (2015)
port_data_2015 <- port_data_clean %>%
  filter(year(date) == 2015)
