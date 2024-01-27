create_forecast_df <- function(forecast, horizon) {
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

plot_arima_forecast <- function(forecast_df) {
  ggplot(data = forecast_df) +
    geom_line(aes(x = date, y = monthly_total_teus)) +
    geom_line(aes(x = date, y = predicted_teus), color = "blue") +
    geom_vline(xintercept = as.Date("2014-12-31"), color = "red", linetype = "dashed") +
    xlim(min(forecast_df$date), max(forecast_df$date))
}
as.Date("2012-01-31")
