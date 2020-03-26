update_population <- function(path,filename='population.csv'){
  "https://raw.githubusercontent.com/frandiego/data/master/population.csv" %>%
    fread() %>%
    fwrite(file.path(path,filename))
}
