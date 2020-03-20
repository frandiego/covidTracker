reset_data <- function(path){
  folder = 'covid_data'
  dir <- file.path(path,folder)
  if(!dir.exists(dir)){
    dir.create(dir)
  }
  update_data(dir)
  if(!file.exists(file.path(dir,'population.csv'))){
    update_population(dir)
  }

}
