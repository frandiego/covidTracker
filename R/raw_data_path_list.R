raw_data_path_list <- function(){
  "https://raw.githubusercontent.com/CSSEGISandData" %>%
    file.path("COVID-19/master/csse_covid_19_data") %>%
    file.path('csse_covid_19_time_series') %>%
    file.path('time_series_covid19_') %>%
    paste0(c('confirmed','deaths','recovered')) %>%
    paste0('_global.csv') %>%
    list(confirmed = .[1], deaths = .[2], recovered = .[3]) %>%
    tail(3)
}
