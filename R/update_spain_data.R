update_spain_data <- function(dir,filename='spain_data.csv'){
  'https://raw.githubusercontent.com/frandiego' %>%
    file.path('data/master/spain_population.csv') -> pop_path
  if(!file.exists(file.path(dir,'spain_population.csv'))){
    fwrite(fread(pop_path,file.path(dir,'spain_population')))
  }

  spain_raw_data_path_list() %>%
    purrr::map(fread) %>%
    purrr::map2(.x=.,.y=names(spain_raw_data_path_list()),
                .f=function(x,y) x[,type:= y]) %>%
    rbindlist() %>%
    setnames(c('CCAA','fecha'),c('region','date')) %>%
    .[,c('region','date','total','type'),with=F] %>%
    dcast(region+date~type,value.var='total') %>%
    .[!grepl('total',tolower(region))] %>%
    .[,date := as.Date(date)] %>%
    merge(.,fread(file.path(pop_path)),
          all.x=T) %>%
    fwrite(file.path(dir,filename))
}
