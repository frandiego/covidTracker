shiny_server <- function(path,folder='covid_data'){
  function(input, output, session){
    rdata <- reactive({
      invalidateLater(60000,session)
      read_covid_data(path=path,folder=folder)
      })
    r_main_numbers <- reactive({
      get_main_numbers(rdata(),input$id_country)
    })
    reactive_infocard_confirmed <- reactive({
      return(argon_info_card(n = r_main_numbers()$confirmed,
                             title = 'Confirmed Infected',
                             icon = icon('ambulance'),width = 4,
                             background_color = 'orange'))
    })
    reactive_infocard_recovered <- reactive({
      return(argon_info_card(n = r_main_numbers()$recovered,
                             title = 'Recovered',
                             icon = icon('heart'),width = 4,
                             background_color = 'green'))
    })
    reactive_infocard_deads <- reactive({
      return(argon_info_card(n = r_main_numbers()$dead,
                             title = 'Deads',
                             icon = icon('cross'),width = 4,
                             background_color = 'red'))
    })
    reactive_predict <- reactive({
      sir <- sir_fit(rdata(),input$id_country)
      sir_predict(sir,400)
    })
    reactive_filter_predict <- reactive({
      reactive_predict() %>%
        .[date<upper_threshold_date(input$id_max_month)] %>% .[]
    })
    reactive_plot <- reactive({
      sir_plot(reactive_filter_predict(),T,10)
    })
    output$id_sir <- highcharter::renderHighchart(expr = reactive_plot())
    output$id_info_conf <-  renderUI(reactive_infocard_confirmed())
    output$id_info_recv <-  renderUI(reactive_infocard_recovered())
    output$id_info_dead <-  renderUI(reactive_infocard_deads())
  }
}

