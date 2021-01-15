library(leaflet)
library(dbplyr)
library(rgdal)

gg <- readOGR('myanmar.geojson')

library(spdplyr)
#from union_myan_group_a.xlsx
gg$total <- c(206515,203481,17179,569906,109051,83747,424498,645329,405631,495140,580359,35796,122317,102612,472847)
gg_select <- gg%>% select(id_1,name,total)


pal <- colorNumeric('Reds',domain = gg_select$total)

labels <- sprintf(
  "<strong>%s</strong><br/>%s people",
  gg_select$name, gg_select$total
) %>% lapply(htmltools::HTML)


leaflet(gg_select) %>%
  addProviderTiles("MapBox",options = providerTileOptions(
    id = "mapbox.light",
    accessToken = 'pk....'
  )) %>%
  addPolygons(
    fillColor = ~pal(total),
    weight = 1,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 2,
      color = "#a9bad4",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = labels,
    labelOptions = labelOptions(
      style = list( "font-weight" = "normal",
                    padding = "3px 8px",
                    "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                    "border-color" = "rgba(0,0,0,0.8)"),
      textsize = "15px",
      direction = "auto"
    )
  )%>%
  addLegend(pal = pal, 
            values = ~total,
            title = 'No of People older than 60',
            position = 'bottomright')


