get_flag_date <- function(data){
  data[,.(confirmed=sum(confirmed,na.rm = T)),
       by=.(country,date)] %>%
    .[,c(0,diff(log(confirmed)) %>%
           fill_strange(.,0)) %>% which.max()+1] -> flag
  return(data[flag][['date']])
}
