library(shiny)
library(leaflet)
library(RColorBrewer)
library(intrval)

ui <- bootstrapPage(
  titlePanel("FEBA - Sofia Air Project (Under construction)"),
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 70, right = 10,
                sliderInput("date_range", 
                            "Date and time of prediction: (NOT INTEGRATED YET)", 
                            min=1,
                            max=24,
                            value=1,
                            #min = as.POSIXct("2019-02-25 00:00"),
                            #max = as.POSIXct("2019-02-25 23:00"),
                            #value = c(as.POSIXct("2019-02-25 01:00")),
                            #step = 3600, # 60 secs * 60 mins
                            #timeFormat = "%a %H:%M", ticks = F, animate = T
                            animate=animationOptions(1000)
                )
  )
)

server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  sofia_summary <- read.csv("./data/sofia_summary_long.csv")
  filteredData <- reactive({
    sofia_summary[]
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(sofia_summary) %>% addTiles() %>%
      fitBounds(~min(lng), ~min(lat), ~max(lng), ~max(lat))
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    
    
  
    pal <- colorFactor("viridis", domain = sofia_summary[,9+input$date_range])
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircleMarkers(
        color = ~pal(sofia_summary[,9+input$date_range]),
        stroke = FALSE, fillOpacity = 0.5) %>%
      addRectangles(lat1 = (min(sofia_summary$lat)-0.01), lng1 = (max(sofia_summary$lng)-0.18), 
                    lat2 = (min(sofia_summary$lat)+0.13), lng2 = (min(sofia_summary$lng)+0.18),
                    fillColor = "transparent")
    pal <- colorFactor("viridis", domain = sofia_summary$time_1)
    
  })
  
  # Use a separate observer to recreate the legend as needed.

}

if (interactive()) shinyApp(ui, server)