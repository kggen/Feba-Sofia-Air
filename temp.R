# creating the dummy data for 24 hours
setwd("/Users/kiril/Documents/Sofia Air/feba_sofia_air")
sofia_summary <- read.csv("./data/sofia_summary.csv")
for (i in 1:24){
  sofia_summary[,(dim(sofia_summary)[2]+1)]<-runif(dim(sofia_summary)[1], 0, 100)
  colnames(sofia_summary)[dim(sofia_summary)[2]]<-paste0("time_",i)
}
write.csv(sofia_summary, file="./data/sofia_summary_long.csv")




# testing colors

pal <- colorFactor("viridis", domain = sofia_summary[,15])

sofia_summary %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(
    color = ~pal(sofia_summary[,15]),
    stroke = FALSE, fillOpacity = 0.5) %>%
  addRectangles(lat1 = (min(sofia_summary$lat)-0.01), lng1 = (max(sofia_summary$lng)-0.18), 
                lat2 = (min(sofia_summary$lat)+0.13), lng2 = (min(sofia_summary$lng)+0.18),
                fillColor = "transparent")
colnames(sofia_summary[9])
