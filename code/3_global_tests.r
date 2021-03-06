###############################
####### 3. Global Tests #######
###############################
library(rgdal)
library(sp)
library(spdep)
library(spatstat)

# Load CT rate data
# "rates"
load('data/race_merged.rdata')

### Pre-process data
empty <- race_merged@data[race_merged@data$total_pop == 0 & race_merged@data$total.stops == 0
                          | is.na(race_merged@data$total_pop),]
rm <- !(race_merged$boro_ct201 %in% empty$boro_ct201)
race_merged2 <- race_merged[rm,]

# I. Clothing
## A. Rook Weighting
# Get the W matrix
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,race_merged2@data$rate.clothing)

### Moran's I
moran.test(race_merged2@data$rate.clothing,lws, zero.policy = T)
moran.mc(race_merged2@data$rate.clothing,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(race_merged2@data$rate.clothing,lws, zero.policy = T)
geary.mc(race_merged2@data$rate.clothing,lws,nsim=999, zero.policy = T)

## B. Queen Weighting
### Pre-process data
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,race_merged2@data$rate.clothing)

### Moran's I
moran.test(race_merged2@data$rate.clothing,lws, zero.policy = T)
moran.mc(race_merged2@data$rate.clothing,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(race_merged2@data$rate.clothing,lws, zero.policy = T)
geary.mc(race_merged2@data$rate.clothing,lws,nsim=999, zero.policy = T)

# II. Furtive Movements
## A. Rook Weighting
### Pre-process data
# Get the W matrix
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,race_merged2@data$rate.furtive)

### Moran's I
moran.test(race_merged2@data$rate.furtive,lws, zero.policy = T)
moran.mc(race_merged2@data$rate.furtive,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(race_merged2@data$rate.furtive,lws, zero.policy = T)
geary.mc(race_merged2@data$rate.furtive,lws,nsim=999, zero.policy = T)

## B. Queen Weighting
### Pre-process data
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,race_merged2@data$rate.clothing)

### Moran's I
moran.test(race_merged2@data$rate.furtive,lws, zero.policy = T)
moran.mc(race_merged2@data$rate.furtive,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(race_merged2@data$rate.furtive,lws, zero.policy = T)
geary.mc(race_merged2@data$rate.furtive,lws,nsim=999, zero.policy = T)

