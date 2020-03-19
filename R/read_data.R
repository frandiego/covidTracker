read_data <- function(config_path){
  read_from_config(path = config_path,
                   parameter = 'path',
                   section = 'DEFAULT') %>%
    fread() %>%
    .[,date := as.Date(date)] %>%
    .[]
}
