read_covid_data <- function(path,folder='covid_data'){
  data <- fread(file.path(path,folder,'data.csv'))
  dpop <- fread(file.path(path,folder,'population.csv'))
  drtm <- fread(file.path(path,folder,'real_time.csv'))
  data[,.(dead=max(dead,na.rm = T),
          recovered = max(recovered,na.rm = T),
          confirmed = max(confirmed,na.rm = T)),
       by = .(country,city,date)] %>%
    .[,.(dead=sum(dead,na.rm = T),
         recovered = sum(recovered,na.rm = T),
         confirmed = sum(confirmed,na.rm = T)),
      by = .(country,date)] -> data
  df <- rbindlist(list(data,drtm))
  df <- merge(df,dpop, by = 'country')
  df[,date:= as.Date(date)] %>%
    .[]
}
