# Load libraries
library(leaflet)
library(rgdal)
library(sp)

# Set 'summited' colour
todo_col <- "#01A194"

# Load shapefile
ukmap <- readOGR("data", "GBR_adm1")
message("Shapefile data were extracted from the GADM database (www.gadm.org), version 2.5, July 2015. They can be used for non-commercial purposes only.  It is not allowed to redistribute these data, or use them for commercial purposes, without prior consent.")

# Load data
munro_df <- read.csv("data/munros_list.csv", stringsAsFactors=FALSE)
message("Munro coordinates were downloaded from http://www.haroldstreet.org.uk/")

# Create a label to use on the map - "Hill name, hill height"
munro_df$map_lab <- paste0(munro_df$Hill.Name, ", ", munro_df$Height, "m")

# Subset summitted munros - these are marked as "Y" in the climbed column of the spreadsheet
munro_done <- munro_df[which(munro_df$Climbed=="Y"),]
message(nrow(munro_done), " munros have been summitted.")

# Subset incomplete munros
munros <- munro_df[which(munro_df$Climbed!="Y"),]
message(nrow(munros), " munros are yet to summit.")

# Set coordinates for major cities
city_coords <- data.frame(Lat=c(56.1190300, 55.8651500, 55.9520600, 56.4691300,
                                57.1436900, 57.4790800),
                          Long=c(-3.9368200, -4.2576300, -3.1964800, -2.9748900,
                                 -2.0981400, -4.2239800),
                          lab=c("Stirling", "Glasgow", "Edinburgh", "Dundee",
                                "Aberdeen", "Inverness"))

# Create map
leaflet() %>%
  addPolygons(data=ukmap, fillColor="goldenrod", color="black", weight=1) %>% # Add polygon for UK outline
  addCircleMarkers(data=munros, label=munros$map_lab, color="black", weight=1, # Add circles for incomplete munros
                   radius=4, fillColor=todo_col, fillOpacity=1) %>%
  addCircleMarkers(data=munro_done, label=munro_done$map_lab, color="black", weight=1, # Add circles for summitted munros
                   radius=4, fillColor="#ffd11a", fillOpacity=1) %>%
  addCircleMarkers(data=city_coords, label=city_coords$lab, color="black", # Add circles for major cities
                   weight=1, radius=4, fillColor="black", fillOpacity=1) %>%
  addLegend(position="topright", colors=c(todo_col, "#ffd11a", "black"), # Add legend in top right
            labels=c("To do", "Completed!", "Cities"), opacity=1) %>%
  setView(lat=56.676790, lng=-5.012916, zoom=6) # Set view center and zoom level
