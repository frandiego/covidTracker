update_data <- function(path){
  raw_data_import() %>%
    setnames(c('city','country','lat','long','date','value','type')) %>%
    .[,-c('city'),with=F] %>%
    dcast(country+lat+long+date~type) %>%
    .[,c('month','day','year') := tstrsplit(date,'/')] %>%
    .[,c('month','day','year') := map(.SD,as.numeric),
      .SDcols = c('month','day','year')] %>%
    .[,year := 2000 + year] %>%
    .[,date := year * 10000 + month * 100 + day] %>%
    .[,date := as.Date(as.character(date),'%Y%m%d')] %>%
    setnames('deaths','dead') %>%
    .[,-c('month','day','year'),with=F] %>%
    list(country = unique(.[,c('country','lat','long'),with=F]) %>%
           setkey(country),
         data = unique(.[,c('country','date','confirmed','recovered','dead'),
                         with=F]) %>%
           setkey(country,date)) %>%
    tail(2) %>%
    walk2(.x=.,.y=file.path(path,c('country.csv','data.csv')),
          .f=function(x,y)fwrite(x,y))
}
