sir_plot <- function(predict,logarithm=T,recovery_days=NULL){
  dt = rlang::duplicate(predict,shallow = F)
  if(is.null(recovery_days)){
    recovery_days = guess_recovery_days(dt)
  }
  dt[,predicted_recovereds:=head(c(rep(0,recovery_days),predicted_recovereds),nrow(dt))]
  dt[,date_str := format(as.Date(date),'%b %d %a')]

  dt %>%
    melt(c('country','date','date_str','index')) %>%
    .[!is.na(value)]-> aux
  highchart() %>%
    hc_xAxis(categories = aux$date_str %>% unique()) %>%
    hc_add_series(data = aux, type = "spline",
                  hcaes(y = value, group = variable),
                  dashStyle = 'solid',
                  marker = list(enabled=F),
                  showInLegend = T) %>%
    hc_yAxis(type = ifelse(logarithm,'logarithmic','linear'),
             title=list(text=ifelse(logarithm,'Population in Logs',
                                    'Population'))) %>%
    hc_xAxis(title='') %>%
    hc_responsive()

}
