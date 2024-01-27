

# Extract start date for time series
start_date <- port_data_2010_2014 %>%
  summarise(year = year(first(date)), 
            month = month(first(date))) %>%
  unlist() %>%
  as.numeric()

# Create time series object
ts_port_data <- ts(port_data_2010_2014$monthly_total_teus, start = start_date, frequency = 12)


# Build ARIMA model
model_arima <- auto.arima(ts_port_data)

summary(model_arima)

checkresiduals(model_arima)

# Create 3, 6, and 12 month forecasts
forecast_3 <- forecast(model_arima, h = 3)
forecast_6 <- forecast(model_arima, h = 6)
forecast_12 <- forecast(model_arima, h = 12)

# Create forecast data set for visualization for each forecast
forecast_df_3 <- create_forecast_df(forecast_3, h = 3)
forecast_df_6 <- create_forecast_df(forecast_6, h = 6)
forecast_df_12 <- create_forecast_df(forecast_12, h = 12)



plot_arima_forecast(forecast_df_3)
plot_arima_forecast(forecast_df_6)
plot_arima_forecast(forecast_df_12)


