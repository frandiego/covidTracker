update_data <- function(path, filename='data.csv'){
  raw_data_import() %>%
    # clean names
    setnames(c('city','country',
               'lat','long','date','value','type')) %>%
    .[,c('month','day','year') := tstrsplit(date,'/')] %>%
    .[,c('month','day','year') := purrr::map(.SD,as.numeric),
      .SDcols = c('month','day','year')] %>%
    .[year<2000,year := 2000 + year] %>%
    .[,date := year * 10000 + month * 100 + day] %>%
    .[,date := as.Date(as.character(date),'%Y%m%d')] %>%
    .[,-c('month','day','year'),with=F] %>%
    setkey(country,city,date) %>%
    .[,country_id := .GRP, by = country] %>%
    .[city!='',city_id := .GRP ,by=.(country_id,city)] %>%
    .[city!='',city_id_max := max(city_id),by=.(country_id)] %>%
    .[city!='',city_id := (city_id_max - city_id) +1] %>%
    .[city=='',city_id := 0] %>%
    .[,city_id := country_id*10^nchar(as.character(max(country_id)))+
        city_id] %>% .[,-c('city_id_max'),with=F] %>%
    dcast(country+country_id+city+city_id+lat+long+date~type,
          value.var='value') %>% setnames('deaths','dead') -> df
  old_ <- c('US',"Cote d'Ivoire","United Kingdom","Korea, South",
            "Bahamas, The","Gambia, The",'Taiwan*',
            'Congo (Brazzaville)', 'Congo (Kinshasa)',
            'Holy See')
  new_ <- c('USA','Ivory Coast', 'UK', "South Korea",
            "Bahamas",'Gambia','Taiwan',
            'Republic of Congo', 'Democratic Republic of Congo',
            'Vatican City')
  for(i in seq_along(old_)){
    df[country==old_[i],country:=new_[i]]
  }
    fwrite(df,file.path(path,filename))
}
