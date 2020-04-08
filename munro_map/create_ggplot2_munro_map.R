# Load libraries
library(ggplot2)
library(rgdal)
library(sp)

# Set map colours
todo_col <- "#01A194"
done_col <- "#ffd11a"

# Load shapefile
ukmap <- readOGR("data", "GBR_adm1")
message("Shapefile data were extracted from the GADM database (www.gadm.org), version 2.5, July 2015. They can be used for non-commercial purposes only.  It is not allowed to redistribute these data, or use them for commercial purposes, without prior consent.")

# Load data
munro_df <- read.csv("data/munro_list.csv", stringsAsFactors=FALSE)
message("Munro coordinates were downloaded from http://www.haroldstreet.org.uk/")

# Subset summitted munros - these are marked as "Y" in the climbed column of the spreadsheet
munro_done <- munro_df[which(munro_df$Climbed=="Y"),]
message(nrow(munro_done), " munros have been summitted.")

# Subset incomplete munros
munros <- munro_df[which(munro_df$Climbed!="Y"),]
message(nrow(munros), " munros are yet to summit.")

# Create map
ggplot() +
  geom_polygon(data=scotmap_df, aes(long, lat, group=group), fill="grey", color="dimgrey") + #  Add polygon for UK outline
  geom_point(data=munros, aes(x=Longitude, y=Latitude), shape=24, fill=todo_col, size=2) + # Add triangles for incomplete munros
  geom_point(data=munros_done, aes(x=Longitude, y=Latitude), shape=24, fill=done_col, size=2) + # Add circles for summitted munros
  theme_classic() + # Apply 'classic' theme
  theme(panel.background = element_rect(fill = "white"), # Make panel background white
        plot.background = element_rect(fill = "white"), # Make plot background white
        panel.grid = element_blank(), # Remove grid
        axis.text = element_blank(), # Remove axes text. title, ticks and line
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.line=element_blank()) +
  coord_fixed(ratio=1.3, xlim=c(-8,-0.5), ylim=c(54.9,59.5)) # Fix coordinate ratio to make map in proportion