get_countries <- function(path,folder='covid_data'){
  read_covid_data(path=path,folder=folder) %>%
    .[,.(n=sum(dead,na.rm = T)),by=.(country,date)] %>%
    .[,.(n=max(n,na.rm = T)),by=country] %>%
    .[order(-n)] %>%
    .[['country']]
}
