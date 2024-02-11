
port_data_raw <- read.socrata(port_data_url)

port_data_2016_raw <- process_image(port_data_2016, image_base_path)
port_data_2017_raw <- process_image(port_data_2017, image_base_path)
port_data_2018_raw <- process_image(port_data_2018, image_base_path)
port_data_2019_raw <- process_image(port_data_2019, image_base_path)
