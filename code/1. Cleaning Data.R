#######################################
######## 1. Cleaning Data #############
#######################################

library(sf)
CT.boundaries <- st_read("shape/2010_Census_Tracts/geo_export_bca342cd-a6e0-423a-849d-f4514a20112a.shp")

#get demographic data
api.key.install(key = "3fd6f9caf6ea78674dc4362076df79153d95770c")
geo <- geo.make(state=c("NY"), county=c(5, 47, 61, 81, 85), tract="*")

race <- acs.fetch(endyear = 2011, geography = geo, 
                  table.number = "C02003", col.names = "pretty")
attr(race, "acs.colnames")
race_df <- data.frame(race@geography$tract, 
                      race@estimate[,c("Detailed Race: Total:",
                                       "Detailed Race: Population of one race: White", 
                                       "Detailed Race: Population of one race: Black or African American")], 
                      stringsAsFactors = FALSE)
rownames(race_df) <- 1:nrow(race_df)
names(race_df) <- c("ct2010", "total_pop", "white", "black")

#need to figure out how to best merge!
race_merged <- merge(CT.bound, race_df, by = "ct2010")

#############################################
######## 2. Subset Stop & Frisk Data ########
#############################################

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

# Subset to weeknights only
# convert date to date object
sfnight$date <- as.Date(sfnight$date)
# Add the day of the week to the data frame
sfnight$day <- weekdays(sfnight$date)
# Select only Sunday - Thursday
sffinal <- sfnight[sfnight$day == "Sunday" | sfnight$day =="Monday" |sfnight$day == "Tuesday" |
                     sfnight$day =="Wednesday" | sfnight$day =="Thursday",]