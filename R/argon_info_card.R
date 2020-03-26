argon_info_card <- function(n,stat,yest,title = 'Total',
                            icon = argonIcon("world"),width=12,
                            background_color = 'blue'){
  argonInfoCard(
    width = width,
    value = pprint(as.integer(n)),
    title = title,
    icon = icon,
    stat=paste0(round(stat*100),' %'),
    description = paste0("yesterday (",pprint(as.integer(yest)),')'),
    stat_icon = icon(ifelse(stat>0,'arrow-up','arrow-down')),
    icon_background = background_color,
    hover_lift = TRUE
  )
}
