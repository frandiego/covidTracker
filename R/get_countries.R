get_countries <- function(path,folder='covid_data'){
  file.path(path,folder,'data.csv') %>%
    fread() %>%
    .[,.(n=sum(dead,na.rm = T)),by=.(country,date)] %>%
    .[,.(n=max(n,na.rm = T)),by=country] %>%
    .[order(-n)] %>%
    .[['country']]
}
