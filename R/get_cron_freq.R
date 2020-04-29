get_cron_freq <- function(freq){
  freq_easy <- c("minutely", "hourly", "daily", "monthly","yearly")
  minute_base <- "*/@minutes@ * * * *"
  if(freq %in% freq_easy){
    freq_ <- freq
  }
  if(grepl('minutes',freq)){
    m_ <- as.integer(gsub('[^[:digit:]]+','',freq))
    freq_ <- gsub('@minutes@',m_,minute_base)
  }
  return(freq_)
}
