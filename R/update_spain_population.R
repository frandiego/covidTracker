update_spain_popualtion <- function(path,filename='spain_population.csv'){
  'https://raw.githubusercontent.com/frandiego/data/master/spain_population.csv' %>%
    fread() %>%
    fwrite(file.path(path,filename))
}
