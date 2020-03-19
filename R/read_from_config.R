read_from_config <- function(path,parameter,section='DEFAULT'){
  ini::read.ini(config_path)[[section]][[parameter]]
}
