create_forecast_arima_df <- function(forecast, h) {

  forecast_end_date <- (forecast_cutoff + months(h) + days(1))
  
  # Create df with date and actual values for the forecast period
  forecast_df <- port_test %>%
    filter(date <= forecast_end_date) %>%
    mutate(predicted_teus = as.numeric(forecast$mean))
  
  # Create a data frame with training and forecast data
  forecast_full_df <- port_train %>%
    mutate(predicted_teus = ifelse(row_number() == n(), monthly_total_teus, NA)) %>%
    rbind(forecast_df)
  
  return(forecast_full_df)
}


# create_forecast_prophet_df <- function(forecast, h) {
#   
#   
#   predictied_values <- forecast %>% slice_tail(n = h) %>% pull(yhat)
#   
#   forecast_end_date <- forecast_cutoff + months(h) 
#   
#   # Create df with date and actual values for the forecast period
#   forecast_df <- port_test %>%
#     filter(date < forecast_end_date) %>%
#     mutate(predicted_teus = predictied_values)
#   
#   # Create a data frame with training and forecast data
#   forecast_df_full <- port_train %>%
#     mutate(predicted_teus = ifelse(row_number() == n(), monthly_total_teus, NA)) %>%
#     rbind(forecast_df)
#   
#   
#   return(forecast_df_full)
# }
# 
# plot_forecast <- function(forecast_df) {
#   ggplot(data = forecast_df) +
#     geom_line(aes(x = date, y = monthly_total_teus)) +
#     geom_line(aes(x = date, y = predicted_teus), color = "blue", linetype = "dashed") +
#     #geom_vline(xintercept = as.Date("2014-12-31"), color = "red", linetype = "dashed") +
#     xlim(min(forecast_df$date), max(forecast_df$date))
# }

create_forecast_prophet_df <- function(forecast, h) {
  
  
  predictied_values <- forecast %>% slice_tail(n = h) %>% select(yhat, yhat_lower, yhat_upper) 
  
  forecast_end_date <- forecast_cutoff + months(h) 
  
  # Create df with date and actual values for the forecast period
  forecast_df <- port_test %>%
    filter(date < forecast_end_date) %>%
    mutate(predicted_teus = predictied_values$yhat,
           predicted_lower = predictied_values$yhat_lower,
           predicted_upper = predictied_values$yhat_upper)
  
  # Create a data frame with training and forecast data
  forecast_df_full <- port_train %>%
    mutate(predicted_teus = ifelse(row_number() == n(), monthly_total_teus, NA),
           predicted_lower = NA,
           predicted_upper = NA) %>%
    rbind(forecast_df)
  
  
  return(forecast_df_full)
}

plot_forecast <- function(forecast_df) {
  ggplot(data = forecast_df) +
    geom_line(aes(x = date, y = monthly_total_teus), color = "grey") + # Actual TEUs in grey
    geom_line(aes(x = date, y = predicted_teus), color = "blue", linetype = "dashed") + # Predicted TEUs in blue dashed line
    geom_ribbon(aes(x = date, ymin = predicted_lower, ymax = predicted_upper), fill = "blue", alpha = 0.2) + # Confidence intervals in light blue
    labs(title = "Monthly TEUs Forecast with Confidence Intervals",
         x = "Date", y = "Monthly Total TEUs") +
    theme_minimal() +
    xlim(min(forecast_df$date, na.rm = TRUE), max(forecast_df$date, na.rm = TRUE)) # Adjusting x-axis limits
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

process_image <- function(file_name, base_path) {
  
  
  # Create the full image path
  image_path <- paste0(base_path, "/", file_name)
  
  # Set up the OCR engine
  eng <- tesseract()
  
  # Perform OCR on the image
  ocr_result <- ocr(image_path, engine = eng)
  
  # Split the text into lines and remove the first two lines
  lines <- unlist(strsplit(ocr_result, "\n"))
  lines <- lines[-(1:2)]
  
  # Initialize vectors for months and values
  months <- vector("character", length(lines))
  second_to_last_values <- vector("character", length(lines))
  
  # Process each line
  for (i in seq_along(lines)) {
    components <- unlist(strsplit(lines[i], "\\s+"))
    
    # Extract the first element for the month
    months[i] <- components[1]
    
    # Extract the second-to-last element
    if (length(components) >= 2) {
      second_to_last_values[i] <- components[length(components) - 1]
    } else {
      second_to_last_values[i] <- NA
    }
  }
  
  # Combine the extracted data into a dataframe and convert to numeric
  df <- data.frame(Month = months, monthly_total_teus = second_to_last_values)
  df$monthly_total_teus <- as.numeric(gsub(",", "", df$monthly_total_teus))
  
  return(df)
}

