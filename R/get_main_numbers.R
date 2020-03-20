get_main_numbers <- function(data){
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
