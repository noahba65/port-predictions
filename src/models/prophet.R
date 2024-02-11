# Prepare the training data by renaming columns for Prophet compatibility
df_prophet <- port_train %>%
  rename(ds = date, y = monthly_total_teus)

# Initialize the Prophet model
m <- prophet()

# Fit the Prophet model with the training data
model_prophet <- fit.prophet(m, df_prophet)

### Cross-validation to evaluate model performance
# `initial`: Specifies the size of the initial training period (3 years here, expressed in days)
# `period`: Determines the spacing between successive cutoff dates (180 days)
# `horizon`: The forecast horizon for each cross-validation step (1 year, expressed in days)
# `units`: Specifies the unit of time used in the `initial`, `period`, and `horizon` parameters
df_cv <- cross_validation(model_prophet, initial = 365 * 3, period = 180, horizon = 365, units = 'days')

# Calculate performance metrics for the cross-validated forecasts
df_performance <- performance_metrics(df_cv)

# Generate future data frame for forecasts over different horizons
future_3 <- make_future_dataframe(model_prophet, periods = 3, freq = "month")
future_6 <- make_future_dataframe(model_prophet, periods = 6, freq = "month")
future_12 <- make_future_dataframe(model_prophet, periods = 12, freq = "month")

# Predict future values using the fitted model for each forecast horizon
forecast_prophet_3 <- predict(model_prophet, future_3)
forecast_prophet_6 <- predict(model_prophet, future_6)
forecast_prophet_12 <- predict(model_prophet, future_12)

# Create forecast data frames for plotting and evaluation
forecast_prophet_df_3 <- create_forecast_prophet_df(forecast_prophet_3, 3)
forecast_prophet_df_6 <- create_forecast_prophet_df(forecast_prophet_6, 6)
forecast_prophet_df_12 <- create_forecast_prophet_df(forecast_prophet_12, 12)

# Plot the forecasts along with actual data
plot_forecast(forecast_prophet_df_3)
plot_forecast(forecast_prophet_df_6)
plot_forecast(forecast_prophet_df_12)

# Calculate Root Mean Square Error (RMSE) for each forecast to evaluate accuracy
rmse(forecast_prophet_df_3, 3)
rmse(forecast_prophet_df_6, 6)
rmse(forecast_prophet_df_12, 12)

# Calculate Mean Absolute Percentage Error (MAPE) for each forecast to evaluate accuracy
mape(forecast_prophet_df_3, 3)
mape(forecast_prophet_df_6, 6)
mape(forecast_prophet_df_12, 12)
