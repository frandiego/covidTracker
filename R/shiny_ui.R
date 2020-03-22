shiny_ui_sidebar <- function(path,folder='covid_data'){
  argonDashSidebar(
    vertical = TRUE,
    skin = "dark",
    background = "white",
    size = "md",
    side = "left",
    id = "my_sidebar",
    brand_url = 'https://geodb.com',
    prettySwitch(slim = T,bigger = T,
                 inputId = "id_log",
                 label = '',
                 value = TRUE,
                 status = "primary"),
    pickerInput(
      inputId = "id_country",
      label = "Country",
      choices = get_countries(path=path,folder=folder),
      selected = 'Spain',
      options = list(
        `live-search` = TRUE)
    ),
    sliderTextInput(
      inputId = "id_max_month",
      label = 'Month',
      grid = TRUE,
      force_edges = TRUE,
      selected = 'May',
      choices = month.abb
    ),
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
      iconList = lapply(X = 1:3, FUN = argonIcon, name = "atom"),
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
        tauchartsOutput('id_metrics')
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
