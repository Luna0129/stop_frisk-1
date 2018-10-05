#######################################
######## 1a. Cleaning Data ############
#######################################

library(sf)
library(acs)
library(ggplot2)

CT.boundaries <- st_read("shape/2010_Census_Tracts/geo_export_bca342cd-a6e0-423a-849d-f4514a20112a.shp")

#get demographic data
api.key.install(key = "3fd6f9caf6ea78674dc4362076df79153d95770c")
geo <- geo.make(state=c("NY"), county=c(5, 47, 61, 81, 85), tract="*")
#Bronx (Bronx County) = 5
#Brooklyn (King County) = 47
#Manhattan (New York County) = 61
#Queens (Queens County) = 81
#Staten Island (Richmond County) = 85

race <- acs.fetch(endyear = 2011, geography = geo, 
                  table.number = "C02003", col.names = "pretty")
attr(race, "acs.colnames")
race_df <- data.frame(race@geography$county, race@geography$tract, 
                      race@estimate[,c("Detailed Race: Total:",
                                       "Detailed Race: Population of one race: White", 
                                       "Detailed Race: Population of one race: Black or African American", 
                                       "Detailed Race: Population of one race: American Indian and Alaska Native",
                                       "Detailed Race: Population of one race: Asian alone", 
                                       "Detailed Race: Population of one race: Native Hawaiian and Other Pacific Islander")], 
                      stringsAsFactors = FALSE)
rownames(race_df) <- 1:nrow(race_df)
names(race_df) <- c("county", "tract", "total_pop", "white", "black", "native.american", "asian", "p.islander")
race_df$county[race_df$county %in% 61] <- 1
race_df$county[race_df$county %in% 5] <- 2
race_df$county[race_df$county %in% 47] <- 3
race_df$county[race_df$county %in% 81] <- 4
race_df$county[race_df$county %in% 85] <- 5

race_df["boro_ct201"] <- paste(race_df$county, race_df$tract, sep = "")

race_merged <- merge(CT.boundaries, race_df, by = "boro_ct201")
#somehow missing 2 observations?
#also no "hispanic/latino" data as of right now
#need to remove the census tracts with no data

#calculate percentages of total population
race_merged["per_white"] <- race_merged$white/race_merged$total_pop
race_merged["per_black"] <- race_merged$black/race_merged$total_pop
race_merged["per_nat.amer"] <- race_merged$native.american/race_merged$total_pop
race_merged["per_asia"] <- race_merged$native.american/race_merged$total_pop
race_merged["per_pisl"] <- race_merged$native.american/race_merged$total_pop

plot(race_merged["per_white"])
plot(race_merged["per_black"])
#plot(race_merged["per_nat.amer"])
#plot(race_merged["per_asia"])
#plot(race_merged["per_pisl"])

#############################################
######## 1b. Subset Stop & Frisk Data #######
#############################################

# Load in the data
load("data/sqf.RData")

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