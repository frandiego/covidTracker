tau_plot_variables <- function(data,country_,gr=T){
  variables <- c('confirmed','dead','recovered')
  df <- data[country%in%country_,c('country','date',variables),with=F]
  if(gr){
    df[,c(variables):=
         purrr::map(.SD,~c(0,diff(log(.)))),.SDcols=c(variables)]

  }
  df[dead>0] %>% melt(c('country','date'))  -> aux

  aux[,variable := factor(variable,
                          levels = c(variables),
                          ordered = T)]
  aux[,value_ctj := casteljau(fill_strange(value,0)),by=.(variable)]

  tauchart(aux) %>%
    tau_line(x=c('date'),
             y=c('value_ctj'),
             color='variable') %>%
    tau_guide_x( tick_format = "%b %d" ) %>%
    tau_tooltip(fields = c('date','value')) %>%
    tau_export_plugin() %>%
    tau_legend() %>%
    tau_title(title = ifelse(gr,'hola','adios'),)

}
