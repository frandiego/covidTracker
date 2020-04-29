casteljau <- function(x,degree = NULL){
  return(bezier::bezier(t = 1:length(x)/length(x),p = x, deg=degree))
}
