get_main_numbers <- function(data,country){
  country_ <- as.vector(country)
  data %>% .[country%in%country_,-c('population'),with=F] %>%
    melt(c('country','date')) %>%
    .[,max_date := max(date,na.rm = T), by = .(country,variable)] %>%
    .[date<max_date&!is.na(date),yest_date := max(date,na.rm = T), by = .(country,variable)] %>%
    .[date<yest_date &!is.na(date), antie := max(date,na.rm=T), by =.(country,variable)] %>%
    list(today = .[date==max_date],yesterday= .[date==yest_date],antie=.[date==antie]) %>%
    tail(3) %>%
    purrr::map(~.[,c('variable','value')]) %>%
    purrr::map(~list(dead=.[variable=='dead',value],
                     recovered=.[variable=='recovered',value],
                     confirmed=.[variable=='confirmed',value])) -> dtl
  if(dtl$today$confirmed==dtl$yesterday$confirmed){
    dtl$yesterday$confirmed = dtl$antie$confirmed
    dtl$yesterday$recovered = dtl$antie$recovered
    dtl$yesterday$dead = dtl$antie$dead
  }

  dtl[['gr']] <- list(dead= dtl$today$dead/dtl$yesterday$dead -1 ,
                      confirmed = dtl$today$confirmed/dtl$yesterday$confirmed -1 ,
                      recovered = dtl$today$recovered/dtl$yesterday$recovered -1 )
  dtl$gr <- purrr::map(dtl$gr,fill_strange)

  return(dtl)
}
