#######################################
######## 1. Cleaning Data #############
#######################################

library(sf)
CT.boundaries <- st_read("2010_Census_Tracts/geo_export_bca342cd-a6e0-423a-849d-f4514a20112a.shp")


# Load in the data
load("~/Github/stop_frisk/data/sqf.RData")

# Subset to 2011
sf2011 <- stops[stops$year==2011,]

# Subset to 10 p.m. to 6 a.m.
# Add non-important seconds place for time
sf2011$time2 <- paste(sf2011$time, ":00")
# First, we need to convert time to time
require("chron")
sf2011$time3 <- chron(times=sf2011$time2)
# Finally, we can subset
sfnight <- sf2011[sf2011$time3 < chron(times="06:00:00") | sf2011$time3 > chron(times="22:00:00"),] 

