guess_recovery_days <- function(dt){
  dt[,actual_recovereds %>% log %>% diff %>%
       purrr::map_dbl(.,~ifelse(.%in%c(NA,Inf),0,.)) %>%
       which.max() + 1] -> recovered_day
  dt[recovered_day][['date']] -> l_date

  dt[actual_confirmeds >= dt[recovered_day][['actual_recovereds']]] %>%
    .[order(date)] %>% head(1) %>% .[['date']] -> f_date
  rd = as.integer(l_date-f_date)
  rd <- ifelse(length(rd)==0,8,rd)
  return(rd)
}
