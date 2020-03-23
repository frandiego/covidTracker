update_scrap_data <- function(path,filename = 'real_time.csv',url = NULL){
  if(is.null(url)){
    url <- 'https://www.worldometers.info/coronavirus'
  }
  web <- xml2::read_html(url)
  df <- as.data.table(html_table(web)[[1]])
  df <- df[,c(names(df)[c(1,2,4,6)]),with=F]
  vars <- c('confirmed','dead','recovered')
  setnames(df,c('country',vars))
  df <- df[!grepl('Total',country)]
  df[,c(vars) := purrr::map(.SD,~gsub(',','',.)),.SDcols=c(vars)]
  df[,c(vars) := purrr::map(.SD,as.numeric),.SDcols=c(vars)]
  df[,c(vars) := purrr::map(.SD,as.integer),.SDcols=c(vars)]
  df[, date:= as.Date(lubridate::today())]
  df= df[,c('country','date','dead','recovered','confirmed'),with=F]
  old_ <- c('Congo','St. Vincent Grenadines',
            "UAE","CAR",
            'S. Korea')
  new_ <- c('Republic of Congo','Saint Vincent and the Grenadines',
            'United Arab Emirates','Central African Republic',
            'South Korea')
  for(i in seq_along(old_)){
    df[country==old_[i],country:=new_[i]]
  }
  fwrite(df,file.path(path,filename))
}
