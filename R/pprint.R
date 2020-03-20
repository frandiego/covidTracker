pprint <- function(x, digits = 2, pct = F,mult=F) {
  pp <- prettyNum(round(as.numeric(x), digits), big.mark = ",", small.mark = ".")
  if(mult) {
    pp <- paste0('x ', pp)
  }
  if (pct) {
    pp <- paste0(pp, " %")
  }
  return(pp)
}
