shiny_ui_sidebar <- function(path,folder='covid_data'){get_countries
  argonDashSidebar(
    vertical = TRUE,
    skin = "dark",
    background = "white",
    size = "md",
    side = "left",
    id = "my_sidebar",
    brand_url = 'https://geodb.com',
    brand_logo = 'https://geodb.com/src/sections/HeaderEN/assets/icons/logo2acee178e01fd3dd965ddfecfc9162bb.svg',
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
      label = "",
      grid = TRUE,
      force_edges = TRUE,
      selected = 'May',
      choices = month.abb
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
    argonTabItems(
      argonTabItem(
        tabName = "tab_sir",
        uiOutput('id_info_recv'),
        uiOutput('id_info_conf'),
        uiOutput('id_info_dead'),
        highcharter::highchartOutput(outputId = 'id_sir',
                                     width = '100%', height = '500px')
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
