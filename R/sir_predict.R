sir_predict <- function(fit,n_days){
  predict <- data.frame(ode(y = fit$initialization, times = 1:n_days,
                            func = fit$SIR, parms = fit$par)) %>% as.data.table()
  predict[,date := seq.Date(from = as.Date(min(fit$data$date)),
                            length.out = n_days,by=1)]
  fit$data <- as.data.table(fit$data)
  fit$data[,date := as.Date(date)]
  dt <- merge(predict,fit$data,by = 'date',all.x = T)
  setnames(dt,'time','index')
  actual_ <- c('confirmed','recovered','dead')
  setnames(dt,actual_,paste0('actual_',actual_,'s'))
  setnames(dt,c('S','I','R'),c('susceptibles','predicted_infecteds',
                               'predicted_recovereds'))
  dt[,country := fit$country]
  setcolorder(dt,c('country','index','date','susceptibles',
                   'predicted_infecteds','predicted_recovereds',
                   'actual_confirmeds','actual_recovereds','actual_deads'))
  return(dt[])
}
