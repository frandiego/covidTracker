reset_data <- function(path,folder = 'covid_data',
                       historic=T,real_time=T,population=F){
  dir <- file.path(path,folder)
  if(!dir.exists(dir)){
    dir.create(dir)
  }
  if(historic){
    update_data(dir,'data.csv')
  }
  if(population){
    update_population(dir,'population.csv')
  }
  if(real_time){
    update_scrap_data(dir,'real_time.csv')
  }
}