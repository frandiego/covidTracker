casteljau <- function(x,degree){
  return(bezier::bezier(t = 1:length(x)/length(x),p = x))
}
