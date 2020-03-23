spain_reset_data <- function(path,folder='covid_data'){
  path_ <- file.path(path,folder)
  'https://raw.githubusercontent.com/frandiego' %>%
    file.path('data/master/spain_population.csv') -> pop_path
  if(!file.exists(file.path(path_,'spain_population.csv'))){
    fwrite(fread(pop_path,file.path(path_,'spain_population')))
  }

  spain_raw_data_path_list() %>%
    purrr::map(fread) %>%
    purrr::map2(.x=.,.y=names(spain_raw_data_path_list()),
                .f=function(x,y) x[,type:= y]) %>%
    rbindlist() %>%
    .[,c('CCAA','date','total','type'),with=F] %>%
    dcast(CCAA+date~type,value.var='total') %>%
    .[!grepl('total',tolower(CCAA))] %>%
    setnames('CCAA','region') %>%
    .[,date := as.Date(date)] %>%
    merge(.,fread(file.path(path_,'spain_population.csv')),
          all.x=T) %>%
    fwrite(file.path(path_,'spain_data.csv'))
}
