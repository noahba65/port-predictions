
# Plot port data 
ggplot(data = port_data_clean) +
  geom_line(aes(x = date, y = monthly_total_teus)) 
