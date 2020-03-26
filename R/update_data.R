update_data <- function(path,folder){
  dir <- file.path(path,folder)
  if(!dir.exists(dir)){
    dir.create(dir)
  }
  update_population(dir)
  update_spain_popualtion(dir)
  update_data(dir)
  update_spain_data(dir)
  update_scrap_data(dir)
}
