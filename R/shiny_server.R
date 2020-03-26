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
      return(argon_info_card(n = r_main_numbers()$today$confirmed,
                             stat=r_main_numbers()$gr$confirmed,
                             yest=r_main_numbers()$yesterday$confirmed,
                             title = 'Confirmed Infected',
                             icon = icon('ambulance'),width = 12,
                             background_color = 'orange'))
    })
    reactive_infocard_recovered <- reactive({
      return(argon_info_card(n = r_main_numbers()$today$recovered,
                             stat=r_main_numbers()$gr$recovered,
                             yest=r_main_numbers()$yesterday$recovered,
                             title = 'Recovered',
                             icon = icon('heart'),width = 12,
                             background_color = 'green'))
    })
    reactive_infocard_deads <- reactive({
      return(argon_info_card(n = r_main_numbers()$today$dead,
                             stat=r_main_numbers()$gr$dead,
                             yest=r_main_numbers()$yesterday$dead,
                             title = 'Deads',
                             icon = icon('cross'),width = 12,
                             background_color = 'red'))
    })
    reactive_plot <- reactive({
      sir_fit_predict(data = rdata(),
                      country = input$id_country,
                      log = input$id_sir_log,
                      month = input$id_max_month,
                      plot=T,
                      lockdown=input$id_power,
                      variables = input$id_variables,
                      type = input$id_type,
                      smooth = input$id_sir_smooth)
    })
    reactive_plot_variables <- reactive({
      hc_plot_variables(data=rdata(),country=input$id_country,
                        gr=input$id_metrics_gr,
                        log=input$id_metrics_log,
                        smooth=input$id_metrics_smooth)
    })
    reactive_metrics_title <- reactive({
      ifelse(input$id_switch,'Growth Rates','Totals')
    })
    output$id_sir <- highcharter::renderHighchart(expr = reactive_plot())
    output$id_info_conf <-  renderUI(reactive_infocard_confirmed())
    output$id_info_recv <-  renderUI(reactive_infocard_recovered())
    output$id_info_dead <-  renderUI(reactive_infocard_deads())
    output$id_metrics_title <- renderText(reactive_metrics_title())
    output$id_metrics <-  highcharter::renderHighchart(reactive_plot_variables())
  }
}

