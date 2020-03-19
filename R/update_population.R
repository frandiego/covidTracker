update_population <- function(path){
  df <- wb(indicator = "SP.POP.TOTL", startdate = 2010, enddate = 2019)
  df <- as.data.table(df)
  df[,c('iso3c','country','date','value'),with=F] %>%
    .[,max_date := max(date),by =c('iso3c','country') ] %>%
    .[date == max_date] %>%
    .[,-c('date','max_date'),with=F] -> df
  dt <- read_data(config_path)
  old_ <- c('United States','Venezuela, RB','Russian Federation',
            'Gambia, The','Brunei Darussalam','Egypt, Arab Rep.',
            'Iran, Islamic Rep.','Korea, Rep.',
            'St. Martin (French part)', 'Bahamas, The', 'Slovak Republic',
            'Congo, Dem. Rep.', 'Congo, Rep.','Czech Republic',
            'St. Lucia')
  new_ <- c('US','Venezuela','Russia',
            'The Gambia','Brunei', 'Egypt', 'Iran','Korea, South',
            'Martinique', 'The Bahamas', 'Slovakia',
            'Congo (Kinshasa)', 'Congo (Brazzaville)','Czechia',
            'Saint Lucia')
  for(i in seq_along(old_)){
    df[country == old_[i], country := new_[i]]
  }
  df_ <- data.table(iso3c='TWN',country='Taiwan',value = 23804590)
  df <- rbindlist(l=list(df,df_))
  intersect_ <- intersect(dt$country,df$country)
  dt <- dt[country %in% intersect_]
  df <- df[country %in% intersect_]
  setnames(df,'value','population')
  fwrite(df,file.path(path,'population.csv'))
}
