
df_prophet <- port_train %>%
  rename(ds = date, y = monthly_total_teus)

m <- prophet()

model_prophet <- fit.prophet(m, df_prophet)

future_3 <- make_future_dataframe(model_prophet, periods = 3, freq = "month")
forecast_prophet_3 <- predict(model_prophet, future_3)

future_6 <- make_future_dataframe(model_prophet, periods = 6, freq = "month")
forecast_prophet_6 <- predict(model_prophet, future_6)

future_12 <- make_future_dataframe(model_prophet, periods = 12, freq = "month")
forecast_prophet_12 <- predict(model_prophet, future_12)

forecast_prophet_df_3 <- create_forecast_prophet_df(forecast_prophet_3, 3)
forecast_prophet_df_6 <- create_forecast_prophet_df(forecast_prophet_6, 6)
forecast_prophet_df_12 <- create_forecast_prophet_df(forecast_prophet_12, 12)


plot_forecast(forecast_prophet_df_3)
plot_forecast(forecast_prophet_df_6)
plot_forecast(forecast_prophet_df_12)

# Calculate rmse for each forecast
rmse(forecast_prophet_df_3, 3)
rmse(forecast_prophet_df_6, 6)
rmse(forecast_prophet_df_12, 12)

# Calculate mape for each forecast
mape(forecast_prophet_df_3, 3)
mape(forecast_prophet_df_6, 6)
mape(forecast_prophet_df_12, 12)


