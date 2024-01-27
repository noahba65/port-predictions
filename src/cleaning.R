
port_data_clean <- port_data_raw %>%
  mutate(date = ymd(date), monthly_total_teus = as.numeric(monthly_total_teus))
