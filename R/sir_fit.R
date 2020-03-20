sir_fit <- function(data,country){
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
    fit <- out[ , 3]
    sum((infected_vector - fit)^2)
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
  return(opt)
}
