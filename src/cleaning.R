# Clean  and select dates and monthly_total_teus columns
# Filters out 2009 and 2016 since 2016 is incomplete in this data
# and 2009 was an outlier due to the Great Recession
port_data_clean <- port_data_raw %>%
  mutate(date = ymd(date), monthly_total_teus = as.numeric(monthly_total_teus)) %>%
  select(date, monthly_total_teus) %>%
  filter(!year(date) %in% c(2009, 2016)) %>%
  arrange(date)

# Select training data between 2009 and 2014
port_data_2010_2014 <- port_data_clean %>%
  filter(year(date) < 2015)

# Select evaluation data from the last complete year (2015)
port_data_2015 <- port_data_clean %>%
  filter(year(date) == 2015)
