update_data <- function(config_path){
  raw_data_import() %>%
    # clean names
    setnames(c('city','country',
               'lat','long','date','value','type')) %>%
    # clean date
    .[,c('month','day','year') := tstrsplit(date,'/')] %>%
    .[,c('month','day','year') := map(.SD,as.numeric),
      .SDcols = c('month','day','year')] %>%
    .[,year := 2000 + year] %>%
    .[,date := year * 10000 + month * 100 + day] %>%
    .[,date := as.Date(as.character(date),'%Y%m%d')] %>%
    .[,-c('month','day','year'),with=F] %>%
    setkey(country,city,date) %>%
    .[,country_id := .GRP, by = country] %>%
    .[city!='',city_id := .GRP ,by=.(country_id,city)] %>%
    .[city!='',city_id_max := max(city_id),by=.(country_id)] %>%
    .[city!='',city_id := (city_id_max - city_id) +1] %>%
    .[city=='',city_id := 0] %>%
    .[,city_id := country_id*10^nchar(as.character(max(country_id)))+city_id] %>%
    .[,-c('city_id_max'),with=F] %>%
    dcast(country+country_id+city+city_id+lat+long+date~type,value.var='value') %>%
    fwrite(read_from_config(path = config_path,
                            section = 'DEFAULT',
                            parameter = 'path'))
}
