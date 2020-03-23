shiny_run <- function(path,folder='covid_data',host=NULL,port=NULL){
  if(!is.null(port)){
    if(is.null(host)){
      host = "127.0.0.1"
    }
    options(shiny.host = host,shiny.port = port)
  }
  shiny::shinyApp(ui = shiny_ui(path=path,folder=folder),
                  server = shiny_server(path=path,folder=folder))

}
