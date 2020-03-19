raw_data_import <- function(){
  raw_data_path_list() %>%
    map(fread) %>%
    map(.,~melt(.,id.vars=head(names(.),4))) %>%
    map2(.x=.,.y=names(raw_data_path_list()),function(x,y) x[,type:=y]) %>%
    rbindlist()
}
