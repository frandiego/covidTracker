
sir_fit_predict <- function(data,
                            country,
                            month = 'May',
                            log=T,
                            plot=T){
  ####################### fit
  country_ <- as.vector(country)
  data[country %in% country_,.(confirmed=sum(confirmed,na.rm = T),
                               dead=sum(dead,na.rm = T),
                               recovered=sum(recovered,na.rm = T)),
       by=.(country,date)] -> df
  df <- df[date>=get_flag_date(df)]

  infected_vector <- df$confirmed
  data[country %in% country_,.(pop=max(population,na.rm = T)),
       by=.(country)][['pop']] %>% sum(na.rm = T) %>% as.integer() -> population
  init_ <- c(S = population-infected_vector[1],I = infected_vector[1],R = 0)
  SIR <- function(time, state, parameters, N = population) {
    par <- as.list(c(state, parameters))
    with(par, {
      dS <- -beta/N * I * S
      dI <- beta/N * I * S - gamma * I
      dR <- gamma * I
      list(c(dS, dI, dR))
    })
  }

  RSS <- function(parameters, fun=SIR,  method = 'lsoda') {
    names(parameters) <- c("beta", "gamma")
    out <- ode(y = init_, times = seq_along(infected_vector),method = method,
               func = fun,
               parms = parameters)
    sum((infected_vector - out[ , 3])^2)
  }

  opt <- optim(c(0.5, 0.5), RSS,
               method = "L-BFGS-B",
               lower = c(0, 0), upper = c(1, 1))
  print(opt$message)
  opt[['initialization']] <- init_
  opt$par <- setNames(opt$par, c("beta", "gamma"))
  opt[['data']] <- df
  opt[['SIR']] <- SIR
  opt[['RSS']] <- RSS
  opt[['country']] <- country
  n_days <- as.integer(as.Date(upper_threshold_date(month)) - as.Date(min(opt$data$date)))

  ####################### predict
  predict <- data.frame(ode(y = opt$initialization, times = 1:n_days,
                            func = opt$SIR, parms = opt$par)) %>%
    as.data.table()
  predict[,date := seq.Date(from = as.Date(min(opt$data$date)),
                            length.out = n_days,by=1)]
  opt$data <- as.data.table(opt$data)
  opt$data[, date := as.Date(date)]
  dt <- merge(predict,opt$data,by = 'date',all.x = T)
  setnames(dt,'time','index')
  actual_ <- c('confirmed','recovered','dead')
  setnames(dt,actual_,paste0('actual_',actual_,'s'))
  setnames(dt,c('S','I','R'),c('susceptibles','predicted_infecteds',
                               'predicted_recovereds'))
  dt[,country := country]
  setcolorder(dt,c('country','index','date','susceptibles',
                   'predicted_infecteds','predicted_recovereds',
                   'actual_confirmeds','actual_recovereds','actual_deads'))


  recovery_days = guess_recovery_days(dt)
  dt[,predicted_recovereds:=head(c(rep(0,recovery_days),
                                   predicted_recovereds),nrow(dt))]
  ####################### plot
  if(plot){
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
    hc_yAxis(type = ifelse(log,'logarithmic','linear'),
             title=list(text=ifelse(log,'Population in Logs',
                                    'Population'))) %>%
    hc_xAxis(title='') %>%
    hc_responsive()
  }else{
    return(dt)
  }
}
