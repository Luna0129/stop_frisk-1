#######################################
########## 2. Calculate Rates #########
#######################################
require(sf)
require(dplyr)

# LOAD CLEANED DATA
load('data/sqf2011_ct.rdata')


# CALCULATE RATES
# A. Clothing
stop.clothing.total <- sqf.ct %>% group_by(boro_ct201) %>% summarise(rt.stop.clth.tot=sum(stopped.bc.clothing)/sum(total_pop))

stop.clothing <- sffinal[sffinal$stopped.bc.clothing == TRUE,]


# B. Furtive Movements
stop.furtive <- sffinal[sffinal$stopped.bc.furtive == TRUE, ]


# C. Stops vs. Frisks? because of Clothing/Furtive
#could look at where stops because of a certain variable also turn into 
#frisks and how that clusters

