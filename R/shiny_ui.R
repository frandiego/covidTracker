shiny_ui_sidebar <- function(path,folder='covid_data'){
  argonDashSidebar(
    vertical = TRUE,
    skin = "dark",
    background = "white",
    size = "md",
    side = "left",
    id = "my_sidebar",
    brand_url = 'https://geodb.com',
    pickerInput(
      inputId = "id_country",
      label = "Country",
      choices = get_countries(path=path,folder=folder),
      selected = 'Spain',
      options = list(
        `live-search` = TRUE)
    ),
    prettySwitch(slim = T,bigger = T,
                 inputId = "id_switch",
                 label = 'Switch Graph',
                 value = F,
                 status = "primary"),
    sliderTextInput(
      inputId = "id_max_month",
      label = 'Month',
      grid = TRUE,
      force_edges = TRUE,
      selected = 'May',
      choices = month.abb
    ),
    sliderInput(inputId = 'id_power',label = 'Lockdown coefficient',
                min = 0, max = 100, step = 1, value = 45),
    selectizeInput(inputId = 'id_variables',
                   label='Variables',
                   choices = c('susceptibles','predicted_infecteds','predicted_recovereds',
                               'actual_confirmeds','actual_recovereds', 'actual_deads'),
                   selected = c('predicted_infecteds',
                                'actual_confirmeds','actual_recovereds', 'actual_deads'),
                   multiple=T),
    argonSidebarDivider(),
    argonBadge(
      text = "Medium Post",
      src = "https://medium.com/@GeoDataBlock/covid19-pandemic-trend-prediction-ccc8b68accb1",
      pill = F,
      status = "success"
    )
  )
}


shiny_ui_navbar <- function(){
  argonDashNavbar()
}
shiny_ui_header <- function(){
  argonDashHeader(
    mask = T,
    opacity = 5,
    gradient = TRUE,
    color = "primary",
    separator = F,
    separator_color = "danger",
    h1("SIR model applied to COVID-19",
       align = "center",style = "color:white"),
  )
}
shiny_ui_footer <- function(){
  return(argonDashFooter())
}
shiny_ui_body <- function(){
  argonDashBody(
    argonTabSet(
      id = "tabset",
      card_wrapper = TRUE,
      horizontal = TRUE,
      circle = FALSE,
      size = "sm",
      width = 12,
      iconList = list(shiny::icon('chart-line'),shiny::icon('chart-bar')),
      argonTab(
        tabName = "SIR",
        active =T,
        uiOutput('id_info_recv'),
        uiOutput('id_info_conf'),
        uiOutput('id_info_dead'),
        highcharter::highchartOutput(outputId = 'id_sir',
                                     width = '100%', height = '500px')
      ),
      argonTab(
        tabName = "Metrics",
        active =F,
        textOutput('id_metrics_title'),
        tauchartsOutput('id_metrics',width = '100%',height = '500px')
      )
    )
  )
}
shiny_ui <- function(path,folder='covid_data'){
  argonDashPage(
    title = "Covid Tracker",
    author = "Fran Diego",
    description = "Web App to track COVID-19",
    sidebar = shiny_ui_sidebar(path=path,folder=folder),
    navbar = shiny_ui_navbar(),
    header = shiny_ui_header(),
    body = shiny_ui_body(),
    footer = shiny_ui_footer()
  )
}
