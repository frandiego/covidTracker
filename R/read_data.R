read_data <- function(config_path){
  path %>%
    file.path('data.csv') %>%
    fread %>%
    .[,date := as.Date(date)] %>%
    .[country == 'Taiwan*',country:= 'Taiwan']-> dt
  dfp <- fread(file.path(path,'population.csv'))
  merge(dt,dfp,by = 'country',all.x = T) %>%
    .[,c('iso3c',names(dt),c('population')),with=F] %>%
    .[]
}
