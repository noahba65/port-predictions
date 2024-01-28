create_forecast_arima_df <- function(forecast, horizon) {
  # Create df with date and actual values for the forecast period
  forecast_df <- port_data_2015 %>%
    filter(month(date) < horizon + 1) %>%
    mutate(predicted_teus = as.numeric(forecast$mean))
  
  # Create a data frame with training and forecast data
  forecast_2010_2015 <- port_data_2010_2014 %>%
    mutate(predicted_teus = ifelse(row_number() == n(), monthly_total_teus, NA)) %>%
    rbind(forecast_df)
  
  return(forecast_2010_2015)
}

create_forecast_prophet_df <- function(forecast, horizon) {
  
  predictied_values <- forecast %>% slice_tail(n = horizon) %>% pull(yhat)
  
  # Create df with date and actual values for the forecast period
  forecast_df <- port_data_2015 %>%
    filter(month(date) < horizon + 1) %>%
    mutate(predicted_teus = predictied_values)
  
  # Create a data frame with training and forecast data
  forecast_2010_2015 <- port_data_2010_2014 %>%
    mutate(predicted_teus = ifelse(row_number() == n(), monthly_total_teus, NA)) %>%
    rbind(forecast_df)
  
  return(forecast_2010_2015)
}

plot_forecast <- function(forecast_df) {
  ggplot(data = forecast_df) +
    geom_line(aes(x = date, y = monthly_total_teus)) +
    geom_line(aes(x = date, y = predicted_teus), color = "blue", linetype = "dashed") +
    #geom_vline(xintercept = as.Date("2014-12-31"), color = "red", linetype = "dashed") +
    xlim(min(forecast_df$date), max(forecast_df$date))
}

rmse <- function(forecast_df, horizon){
  # Extract the relevant period for RMSE calculation
  horizon_period <- forecast_df %>% slice_tail(n = horizon)
  
  # Calculate the squared differences
  squared_diffs <- (horizon_period$monthly_total_teus - horizon_period$predicted_teus) ^ 2
  
  # Calculate the RMSE
  rmse <- sqrt(mean(squared_diffs))
  
  return(rmse)
}

mape <- function(forecast_df, horizon) {
  # Extract the relevant period for MAPE calculation
  horizon_period <- forecast_df %>% slice_tail(n = horizon)
  
  # Calculate the absolute percentage differences
  abs_perc_diffs <- abs((horizon_period$monthly_total_teus - horizon_period$predicted_teus) / horizon_period$monthly_total_teus)
  
  # Calculate the MAPE
  mape <- mean(abs_perc_diffs, na.rm = TRUE) * 100
  
  return(round(mape, 2))
}
