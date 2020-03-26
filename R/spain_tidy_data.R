spain_tidy_data <- function(path_data,path_population){
  df <- fread(path_data)
  dp <- fread(path_population)
  df <- merge(df,dp,all.x=T)
  df[,recovered := 0]
  df[,country := region]
  df <- df[,c('country','date','dead','recovered',
              'confirmed','population'),with=F]
  return(df)
}
