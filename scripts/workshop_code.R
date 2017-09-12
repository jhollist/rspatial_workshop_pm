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

station_rides <- read.csv(here("data/station_rides.csv"), stringsAsFactors = FALSE)

dc_metro_sttn <- dc_metro_sttn %>%
  left_join(station_rides, by = c("NAME" = "Ent.Station"))

busy_sttn <- dc_metro_sttn %>%
  filter(avg_wkday > 10000) %>%
  select(name = NAME, ridership = avg_wkday, line = LINE) %>%
  arrange(desc(ridership))

esri_alb_p4 <- projection(dc_nlcd)
utm_z18 <- "+proj=utm +zone=18 +ellps=WGS84 +datum=WGS84 +units=m +no_defs "
dc_metro_alb <- st_transform(dc_metro, esri_alb_p4)
dc_elev_alb <- projectRaster(dc_elev,crs = esri_alb_p4)

dc_bnd_alb <- us_states %>%
  filter(STUSPS == "DC") %>%
  st_transform(esri_alb_p4)



