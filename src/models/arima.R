

ggplot(data = port_data_clean) +
  geom_line(aes(x = date, y = monthly_total_teus)) 
  
start_date <- port_data_clean %>%
  summarise(year = year(first(date)), 
            month = month(first(date))) %>%
  unlist() %>%
  as.numeric()

port_data_ts <- ts(port_data_clean$monthly_total_teus, start = start_date, frequency = 12)



