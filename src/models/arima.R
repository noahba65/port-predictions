

# Extract start date for time series
start_date <- port_data_2009_2014 %>%
  summarise(year = year(first(date)), 
            month = month(first(date))) %>%
  unlist() %>%
  as.numeric()

# Create time series object
ts_port_data <- ts(port_data_2009_2014$monthly_total_teus, start = start_date, frequency = 12)


# Build ARIMA model
model_arima <- auto.arima(ts_port_data)

summary(model_arima)

checkresiduals(model_arima)

# Create 3, 6, and 12 month forecasts
forecast_3 <- forecast(model_arima, h = 3)
forecast_6 <- forecast(model_arima, h = 6)
forecast_12 <- forecast(model_arima, h = 12)

# Create df with date and actual values
forecast_3_df <- port_data_2015 %>%
  filter(month(date) < 4) 

# Add predicted column
forecast_3_df$predicted_teus <- as.numeric(forecast_3$mean)

# Create a data frame with training and forecast data
forecast_2009_2015_3 <- port_data_2009_2014 %>%
  # make the predicted_teus equal to the monthly_total_teus and all others NA
  mutate(predicted_teus = ifelse(row_number() == n(), monthly_total_teus, NA )) %>%
  rbind(forecast_3_df)

ggplot(data = forecast_2009_2015_3) +
  geom_line(aes(x = date, y = monthly_total_teus)) +
  geom_line(aes(x = date, y = predicted_teus), color = "blue") +
  geom_vline(xintercept = as.Date("2014-12-31"), color = "red", linetype = "dashed") +
  xlim(as.Date("2014-01-31"), as.Date("2015-04-24"))



