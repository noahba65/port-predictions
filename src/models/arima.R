# Extract start date for time series
start_date <- port_train %>%
  summarise(year = year(first(date)), 
            month = month(first(date))) %>%
  unlist() %>%
  as.numeric()

# Create time series object
ts_port_data <- ts(port_train$monthly_total_teus, start = start_date, frequency = 12)

# Build ARIMA model
model_arima <- auto.arima(ts_port_data)

summary(model_arima)

checkresiduals(model_arima)

# Create 3, 6, and 12 month forecasts
forecast_arima_3 <- forecast(model_arima, h = 3)
forecast_arima_6 <- forecast(model_arima, h = 6)
forecast_arima_12 <- forecast(model_arima, h = 12)

# Create forecast data set for visualization for each forecast
forecast_arima_df_3 <- create_forecast_arima_df(forecast_arima_3, h = 3)
forecast_arima_df_6 <- create_forecast_arima_df(forecast_arima_6, h = 6)
forecast_arima_df_12 <- create_forecast_arima_df(forecast_arima_12, h = 12)

# Plot Forecasts
plot_forecast(forecast_arima_df_3)
plot_forecast(forecast_arima_df_6)
plot_forecast(forecast_arima_df_12)

# Calculate rmse for each forecast
rmse(forecast_arima_df_3, 3)
rmse(forecast_arima_df_6, 6)
rmse(forecast_arima_df_12, 12)

# Calculate mape for each forecast
mape(forecast_arima_df_3, 3)
mape(forecast_arima_df_6, 6)
mape(forecast_arima_df_12, 12)
