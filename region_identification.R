library(sf)
library(sp)
library(rgdal)
library(dplyr)
library(raster)
require(gdistance)

# lat, long
lat = 38.913422
long = -75.427033
threshold = 500

# Can optionally make a command line program 
# args <- commandArgs()


buildings <- readOGR(
  dsn= "building-shapefiles/" ,
  layer="gis_osm_buildings_a_free_1",
  verbose=FALSE
)

num_buildings = 0
search_radius = 0.00005

while(num_buildings < threshold){
  place_ext = extent(long-search_radius, long+search_radius, lat-search_radius, lat+search_radius)
  num_buildings = as.integer(length(crop(buildings, place_ext)))
  search_radius = search_radius + 0.005
  # print(num_buildings)
}

cat("Search radius: ", search_radius, "\n")
cat("Extent: (", c(long-search_radius, long+search_radius, lat-search_radius, lat+search_radius), ")")
