
port_data_raw <- read.socrata(port_data_url)

port_data_2016_raw <- process_image(image_2016_file_name, image_base_path)
port_data_2017_raw <- process_image(image_2017_file_name, image_base_path)

