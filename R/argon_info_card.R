argon_info_card <- function(n,title = 'Total',
                            icon = argonIcon("world"),width=12,
                            background_color = 'blue'){
  argonInfoCard(
    width = width,
    value = pprint(as.integer(n)),
    title = title,
    icon = icon,
    icon_background = background_color,
    hover_lift = TRUE
  )
}
