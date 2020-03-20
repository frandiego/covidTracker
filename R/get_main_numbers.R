get_main_numbers <- function(data,country){
  country_ <- as.vector(country)
  data[country==country_] %>%
    .[date==max(date)] %>%
    .[,c('dead','recovered','confirmed'),with=F] %>%
    as.list()
}
