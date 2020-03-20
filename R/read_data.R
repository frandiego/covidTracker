read_data <- function(path){
  path %>%
    file.path('data.csv') %>%
    fread %>%
    .[,date := as.Date(date)] %>%
    .[country == 'Taiwan*',country:= 'Taiwan']
}
