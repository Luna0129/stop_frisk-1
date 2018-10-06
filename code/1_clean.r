#######################################
######## 1a. Cleaning Data ############
#######################################

library(sf)
library(acs)
library(sp)
library(ggplot2)
require("chron")


# CENSUS TRACT POLYGONS
CT.boundaries <- st_read("shape/2010_Census_Tracts/geo_export_bca342cd-a6e0-423a-849d-f4514a20112a.shp")


# CENSUS TRACT DATA FROM CENSUS API
#get demographic data
api.key.install(key = "3fd6f9caf6ea78674dc4362076df79153d95770c")
geo <- geo.make(state=c("NY"), county=c(5, 47, 61, 81, 85), tract="*")
#Bronx (Bronx County) = 5
#Brooklyn (King County) = 47
#Manhattan (New York County) = 61
#Queens (Queens County) = 81
#Staten Island (Richmond County) = 85

# Aggregate race demographics to match SQF race categories
race <- acs.fetch(endyear = 2011, geography = geo, 
                  table.number = "B03002", col.names = "pretty")
attr(race, "acs.colnames")
race_df <- data.frame(race@geography$county, race@geography$tract, 
                      race@estimate[,c("Hispanic or Latino by Race: Total:",
                                       "Hispanic or Latino by Race: Not Hispanic or Latino: White alone", 
                                       "Hispanic or Latino by Race: Not Hispanic or Latino: Black or African American alone", 
                                       "Hispanic or Latino by Race: Not Hispanic or Latino: American Indian and Alaska Native alone",
                                       "Hispanic or Latino by Race: Not Hispanic or Latino: Asian alone", 
                                       "Hispanic or Latino by Race: Hispanic or Latino: White alone", 
                                       "Hispanic or Latino by Race: Hispanic or Latino: Black or African American alone")], 
                      stringsAsFactors = FALSE)
rownames(race_df) <- 1:nrow(race_df)
names(race_df) <- c("county", "tract", "total_pop", "white", "black", "native.american", "asian", "white.hisp", "black.hisp")
race_df["other"] <- race_df$total_pop - (race_df$white + race_df$black + race_df$native.american + 
                                           race_df$asia + race_df$white.hisp + race_df$black.hisp)
# Standardize census tract codes between shapefile (coded by borough) and census (coded by county)
race_df$county[race_df$county %in% 61] <- 1
race_df$county[race_df$county %in% 5] <- 2
race_df$county[race_df$county %in% 47] <- 3
race_df$county[race_df$county %in% 81] <- 4
race_df$county[race_df$county %in% 85] <- 5
race_df["boro_ct201"] <- paste(race_df$county, race_df$tract, sep = "")


# MERGE CENSUS TRACT DEMOGRAPHICS W/ SHAPE POLYS
race_merged <- merge(CT.boundaries, race_df, by = "boro_ct201")

#calculate percentages of total population
race_merged["per_white"] <- race_merged$white/race_merged$total_pop
race_merged["per_black"] <- race_merged$black/race_merged$total_pop
race_merged["per_nat.amer"] <- race_merged$native.american/race_merged$total_pop
race_merged["per_asia"] <- race_merged$asian/race_merged$total_pop
race_merged["per_whisp"] <- race_merged$white.hisp/race_merged$total_pop
race_merged["per_bhisp"] <- race_merged$black.hisp/race_merged$total_pop
race_merged["per_other"] <- race_merged$other/race_merged$total_pop


# DIAGNOSTIC PLOTS
plot(race_merged["per_white"])
plot(race_merged["per_black"])
#plot(race_merged["per_nat.amer"])
#plot(race_merged["per_asia"])
#plot(race_merged["per_whisp"])
#plot(race_merged["per_bhisp])
plot(race_merged["per_other"])


#############################################
######## 1b. Subset Stop & Frisk Data #######
#############################################

# Load all SQF data
load("data/sqf.RData")


# SUBSETTING DATA
# Subset to 2011
sf2011 <- stops[stops$year==2011,]

# Subset to 10 p.m. to 6 a.m.
# First, we need to convert time to time & add trivial seconds place for time
sf2011$time <- chron(times=paste0(sf2011$time, ":00"))
sfnight <- sf2011[sf2011$time < chron(times="06:00:00") | sf2011$time > chron(times="22:00:00"),] 

# Subset to weeknights only
# convert date to date object
sfnight$date <- as.Date(sfnight$date)
# Add the day of the week to the data frame
sfnight$day <- weekdays(sfnight$date)
# Select only Sunday - Thursday
sf.final <- sfnight[sfnight$day %in% c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'),]


# MERGING WITH CENSUS TRACT DATA
# Drop instances w/ missing lon, lat
apply(sf.final[, c('lon', 'lat')], MARGIN=2, FUN=function(col) {table(is.na(col))})
sf.final <- sf.final[!is.na(sf.final$lon) & !is.na(sf.final$lat),]

# Convert to sf object
sqf.sf <- st_as_sf(sf.final,
    coords=c('lon', 'lat'),
    crs=st_crs(race_merged))

# Variables of interest
sqf.vars <- c(names(sqf.sf))
ct.vars <- c('boro_ct201', 'boro_name', 'ntaname',
    'white', 'black', 'native.american', 'asian', 'white.hisp', 'black.hisp', 'other', 'total_pop',
    'per_white', 'per_black', 'per_nat.amer', 'per_asia', 'per_whisp', 'per_bhisp', 'per_other')

# Merge with census tract data
sqf.ct <- st_join(sqf.sf[sqf.vars],
    race_merged[ct.vars])


# SAVE CLEANED DATA
save(sqf.ct, file='data/sqf2011_ct.rdata')
