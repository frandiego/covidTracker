upper_threshold_date <- function(x){
  m_ <-  which(tolower(month.abb) == tolower(x))
  d_ <- m_*100+01 + 20200000
  dd_ <- as.Date(as.character(d_),'%Y%m%d')
  dd_ + base::months(1)
}
