read_covid_data <- function(path){
  path %>%
    file.path('covid_data/data.csv') %>%
    fread %>%
    .[,date := as.Date(date)] %>%
    .[country == 'Taiwan*',country:= 'Taiwan']-> dt
  dfp <- fread(file.path(path,'covid_data/population.csv'))
  merge(dt,dfp,by = 'country',all.x = T) %>%
    .[,c('iso3c',names(dt),c('population')),with=F] %>%
    .[]
}
