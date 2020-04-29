hc_plot_variables <- function(data,country,gr,log,smooth){
  country_ <- as.vector(country)
  variables <- c('confirmed','dead','recovered')
  colors <- c('#5e72e4','#f5365c','#2dce89')
  varcol <- data.table(variable=variables,color=colors)
  df <- data[country%in%country_,c('country','date',variables),with=F]
  variables_zero <-  variables[colSums(df[,variables,with=F],na.rm = T)==0]
  if(length(variables_zero)>0){
    df <- df[,-c(variables_zero),with=F]
    variables <- setdiff(variables,variables_zero)
  }
  if(gr){
    df[,c(variables):=
         purrr::map(.SD,~c(0,diff(log(.)))),.SDcols=c(variables)]

  }
  df[dead>0] %>% melt(c('country','date'))  -> aux

  aux[,variable := factor(variable,
                          levels = c(variables),
                          ordered = T)]
  if(log){
    aux[,value:=log(fill_strange(value,0))]
  }
  if(smooth){
    aux[,value := casteljau(fill_strange(value,0)),by=.(variable)]
  }
  aux <-aux %>% merge(varcol,by='variable',all.x = T)

  highchart() %>%
    hc_xAxis(categories = aux$date %>% unique()) %>%
    hc_add_series(data = aux, type = "spline",
                  hcaes(y = round(value,3), group=variable),
                  dashStyle = 'solid',
                  marker = list(enabled=F),
                  lineWidth=4,
                  showInLegend = T
    ) %>%
    hc_colors(colors = aux[,unique(color)]) %>%
    hc_tooltip(crosshairs = TRUE,  sort = TRUE, table = TRUE) %>%
    hc_responsive()
}
