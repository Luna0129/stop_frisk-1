#######################################
########## 2. Calculate Rates #########
#######################################
load('data/ct_data.rdata')

#Rate calculations
race_merged@data$rate.clothing <- race_merged@data$stopped.clothing/race_merged@data$total.stops
race_merged@data$rate.furtive <- race_merged@data$stopped.furtive/race_merged@data$total.stops
race_merged@data$rate.clothing[is.na(race_merged@data$rate.clothing)] <- 0
race_merged@data$rate.furtive[is.na(race_merged@data$rate.furtive)] <- 0

save(race_merged, file='data/race_merged.rdata')
