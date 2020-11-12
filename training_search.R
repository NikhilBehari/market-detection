library(sf)
library(sp)
library(rgdal)
library(dplyr)
library(raster)
require(gdistance)

regions = read.csv("regions.csv")
markets = read.csv("markets.csv")
places <- readOGR(
  dsn= "building-shapefiles/" ,
  layer="gis_osm_places_free_1",
  verbose=FALSE
)
buildings <- readOGR( 
  dsn= "building-shapefiles/" , 
  layer="gis_osm_buildings_a_free_1",
  verbose=FALSE
)
roads = readOGR(
  dsn = "building-shapefiles/", 
  layer="gis_osm_roads_free_1", 
  verbose=FALSE
)

crop_buildings = function(region_bounds, name="1"){
  region_buildings = crop(buildings, extent(region_bounds$left, region_bounds$right, region_bounds$bottom, region_bounds$top))
  region_filename = c("region", name)
  region_filename = paste(region_filename, collapse="")
  writeOGR(region_buildings, "cropped-shp/", region_filename, driver="ESRI Shapefile")
}

crop_roads = function(region_bounds, name="1"){
  region_buildings = crop(roads, extent(region_bounds$left, region_bounds$right, region_bounds$bottom, region_bounds$top))
  region_filename = c("region", name)
  region_filename = paste(region_filename, collapse="")
  writeOGR(region_buildings, "roads-cropped/", region_filename, driver="ESRI Shapefile")
}
crop_places = function(region_bounds, name="1"){
  region_buildings = crop(places, extent(region_bounds$left, region_bounds$right, region_bounds$bottom, region_bounds$top))
  region_filename = c("region", name)
  region_filename = paste(region_filename, collapse="")
  writeOGR(region_buildings, "places-cropped/", region_filename, driver="ESRI Shapefile")
}

find_markets = function(){
  region_list = c(1, 2, 3, 4)
  search_radius = 0.0045
  markets_found = data.frame(region=NA, lat=NA, long=NA, is_market=NA, radius_search=NA, buildings=NA, roads=NA)
  
  for(region_index in region_list){
    region_filename = c("region", region_index)
    region_filename = paste(region_filename, collapse="")
    
    region_places = readOGR( 
      dsn= "places-cropped/" , 
      layer= region_filename,
      verbose=FALSE
    )
    region_buildings = as.data.frame(region_places)
    region_buildings = readOGR( 
      dsn= "buildings-cropped/" , 
      layer= region_filename,
      verbose=FALSE
    )
    region_roads = readOGR( 
      dsn= "roads-cropped/" , 
      layer= region_filename,
      verbose=FALSE
    )
    
    for (row in 1:nrow(region_places)){
      tryCatch({
        temp_place = (region_places[row, ])
        lat = temp_place$coords.x2
        long = temp_place$coords.x1
        place_ext = extent(long-search_radius, long+search_radius, lat-search_radius, lat+search_radius)
        
        num_buildings = as.integer(length(crop(region_buildings, place_ext)))
        num_roads = as.integer(length(crop(region_roads, place_ext)))
        
        is_market = FALSE
        if(num_buildings > 20 & num_roads > 1){
          is_market = TRUE
        }
        
        markets_found[nrow(markets_found)+1,] = c(region_index, lat, long, is_market, search_radius, num_buildings, num_roads)
      }, error = function(e){
        
      })
    }
    
  }
  
  return(markets_found)
}
markets_found = find_markets()
markets_found
write.csv(markets_found, "markets_found_1.csv")


