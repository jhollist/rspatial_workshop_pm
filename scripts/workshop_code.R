# Packages
library(here)
library(sf)
library(raster)
library(dplyr)

# Read in data
dc_metro <- st_read(here("data/Metro_Lines.shp"))
dc_metro_sttn <- st_read(here("data/metrostations.geojson"))
us_states <- st_read(here("data/tl_2015_us_state.shp"))
dc_elev <- raster(here("data/dc_ned.tif"))
dc_nlcd <- raster(here("data/dc_nlcd.tif"))


# Write out data
st_write(dc_metro, here("data/dc_metro.geojson"))

# Using dplyr with sf
dc_red_only <- dc_metro %>%
  filter(NAME == "red")



