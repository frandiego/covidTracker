raw_data_import <- function(){
  raw_data_path_list() %>%
    purrr::map(fread) %>%
    purrr::map(.,~melt(.,id.vars=head(names(.),4))) %>%
    purrr::map2(.x=.,.y=names(raw_data_path_list()),
                function(x,y) x[,type:=y]) %>%
    rbindlist()
}
