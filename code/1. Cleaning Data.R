#######################################
######## 1. Cleaning Data #############
#######################################

library(sf)
CT.boundaries <- st_read("2010_Census_Tracts/geo_export_bca342cd-a6e0-423a-849d-f4514a20112a.shp")


# Load in the data
load("~/Github/stop_frisk/data/sqf.RData")

# Subset to 2011
sf2011 <- stops[stops$year==2011,]