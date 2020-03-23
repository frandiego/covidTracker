spain_tidy_data <- function(df){
  df[,recovered := 0]
  df[,country := region]
  df <- df[,c('country','date','dead','recovered',
              'confirmed','population'),with=F]
  return(df)
}
