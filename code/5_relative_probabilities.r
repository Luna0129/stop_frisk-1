#######################################
###### 5. Relative Probabilities ######
#######################################

# Here we will calculate the probabilities of being stopped for X in the cluster
# as opposed to being outside of the cluster to determine relative risk.

# Load CT rate data
# "rates"
load('data/race_merged.rdata')

### Pre-process data
empty <- race_merged@data[race_merged@data$total_pop == 0 & race_merged@data$total.stops == 0
                          | is.na(race_merged@data$total_pop),]
rm <- !(race_merged$boro_ct201 %in% empty$boro_ct201)
race_merged2 <- race_merged[rm,]

#  Load local moran's test results
load('data/local_moran_tests.rdata')

# Merge data together
merged <- merge(race_merged2, results, by='row.names')
# 15 census tracts do not have p-values (some because they don't have neighbors, others because?)
drops <- apply(is.na(merged@data[, c('clothing.rook', 'clothing.queen', 'furtive.rook', 'furtive.queen')]), 1, any)
merged <- merged@data[!drops,]

# Calculate relative probabilities

relativeProb <- function(stopType='clothing', nbType='rook', denom='total_pop', data=merged) {
    # Probability of stop within hotspots / probability of stop outside of hotspots
    # Argument values
    # stop: ['clothing', 'furtive']
    # nbType: ['rook', 'queen']
    # denom: ['total_pop', 'white', 'black', 'native.american', 'asian', 'white.hisp', 'black.hisp', 'other']

    # Variables for specified stop type and neighbor type
    if (stopType == 'clothing') {
        stopVar <- 'rate.clothing'

        if (nbType == 'rook') {
            hotspots <- data$clothing.rook <= 0.05
        } else {
            hotspots <- data$clothing.queen <= 0.05
        }
    } else {
        stopVar <- 'rate.furtive'
        
        if (nbType == 'rook') {
            hotspots <- data$furtive.rook <= 0.05
        } else {
            hotspots <- data$furtive.queen <= 0.05
        }
    }

    # Calculate probability within hotspot
    prob.hot <- weighted.mean(data[hotspots, stopVar] / data[hotspots, denom], data[hotspots, denom], na.rm=TRUE)

    # Calcuate probability outside hotspot
    prob.not <- weighted.mean(data[!hotspots, stopVar] / data[!hotspots, denom], data[!hotspots, denom], na.rm=TRUE)

    return( prob.hot / prob.not)
}


