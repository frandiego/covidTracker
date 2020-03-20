fill_strange <- function(x,fill=0){
  x[is.na(x)] = fill
  x[is.nan(x)] = fill
  x[is.infinite(x)] = fill
  x
}
