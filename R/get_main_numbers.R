get_main_numbers <- function(data,country){
  country_ <- as.vector(country)
  data[country==country_] %>%
    .[,.(dead=max(dead,na.rm = T),
         recovered = max(recovered,na.rm = T),
         confirmed = max(confirmed,na.rm = T),
         population = max(population,na.rm = T)),
      by = .(country,city)] %>%
    .[,.(dead=max(dead,na.rm = T),
         recovered = max(recovered,na.rm = T),
         confirmed = max(confirmed,na.rm = T),
         population = max(population,na.rm = T))] %>%
    as.list()
}
