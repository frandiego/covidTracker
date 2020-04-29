spain_raw_data_path_list <- function(){
  "https://raw.githubusercontent.com/datadista" %>%
    file.path("datasets/master/COVID%2019") %>%
    list(discharged = file.path(.,'ccaa_covid19_altas_long.csv'),
         confirmed = file.path(.,'ccaa_covid19_casos_long.csv'),
         dead = file.path(.,'ccaa_covid19_fallecidos_long.csv'),
         uci = file.path(.,'ccaa_covid19_uci_long.csv')) %>%
    tail(4)
}
