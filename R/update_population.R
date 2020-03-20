update_population <- function(path,filename='population.csv'){
  df <- wb(indicator = "SP.POP.TOTL", startdate = 2010, enddate = 2019)
  df <- as.data.table(df)
  df[,c('iso3c','country','date','value'),with=F] %>%
    .[,max_date := max(date),by =c('iso3c','country') ] %>%
    .[date == max_date] %>%
    .[,-c('date','max_date'),with=F] -> df
  old_ <- c('United States','Venezuela, RB','Russian Federation',
            'Gambia, The','Brunei Darussalam','Egypt, Arab Rep.',
            'Iran, Islamic Rep.','Korea, Rep.',
            'St. Martin (French part)', 'Bahamas, The', 'Slovak Republic',
            'Congo, Dem. Rep.', 'Congo, Rep.','Czech Republic',
            'St. Lucia','United Kingdom','St. Vincent and the Grenadines')
  new_ <- c('USA','Venezuela','Russia',
            'Gambia','Brunei', 'Egypt', 'Iran','South Korea',
            'Martinique', 'Bahamas', 'Slovakia',
            'Republic of Congo', 'Democratic Republic of Congo',
            'Czechia',
            'Saint Lucia', 'UK','Saint Vincent and the Grenadines')
  for(i in seq_along(old_)){
    df[country == old_[i], country := new_[i]]
  }
  if(!'Taiwan' %in% df[,unique(country)]){
    df_ <- data.table(iso3c='TWN',country='Taiwan',value = 23804590)
    df <- rbindlist(l=list(df,df_))
  }
  if(!'Ivory Coast' %in% df[,unique(country)]){
    df_ <- data.table(iso3c='CIV',country='Ivory Coast',value = 23740424)
    df <- rbindlist(l=list(df,df_))
  }
  if(!'Kyrgyzstan' %in% df[,unique(country)]){
    df_ <- data.table(iso3c='KGZ',country='Kyrgyzstan',value = 6389500)
    df <- rbindlist(l=list(df,df_))
  }
  if(!'Vatican City' %in% df[,unique(country)]){
    df_ <- data.table(iso3c='VAT',country='Vatican City',value = 1000)
    df <- rbindlist(l=list(df,df_))
  }
  setnames(df,'value','population')
  df[,.(population = max(population,na.rm = T)),by=.(country)] -> df
  fwrite(df,file.path(path,filename))
}
