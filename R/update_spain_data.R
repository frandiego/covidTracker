update_spain_data <- function(dir,filename='spain_data.csv'){
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
    fwrite(file.path(dir,filename))
}
