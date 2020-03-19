raw_data_path_list <- function(){
  "https://raw.githubusercontent.com/CSSEGISandData" %>%
    file.path("COVID-19/master/csse_covid_19_data") %>%
    file.path('csse_covid_19_time_series') %>%
    file.path('time_series_19-covid-') %>%
    paste0(c('Confirmed','Recovered','Deaths')) %>%
    paste0('.csv') %>%
    list(confirmed = .[1], recovered = .[2], deaths = .[3])
}
