#######################################
######## 1. Cleaning Data #############
#######################################


# Load in the data
load("~/Github/stop_frisk/data/sqf.RData")

# Subset to 2011
sf2011 <- stops[stops$year==2011,]