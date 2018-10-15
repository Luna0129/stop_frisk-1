###############################
####### 3. Global Tests #######
###############################
library(sf)
library(sp)
library(spdep)
library(spatstat)

load('data/rates.rdata')



autoCor <- function(geometry, crs, rateVar, test='moran', nsim, queen=FALSE) {
    sp.poly <- as.SpatialPolygons.PolygonsList(list(geometry), crs)
    nbs <- poly2nb(sp.poly, queen=queen)
    lws <- nb2listw(nbs)

    if (test == 'moran') {
        return(moran.mc(rateVar, lws, nsim=nsim))
    } else {
        return(geary.mc(rateVar, lws, nsim=nsim))
    }
}

# I. Clothing
## A. Rook Weighting
### Pre-process data
# Have to remove the tracts from lws not in data
rm <- race_merged$boro_ct201 %in% rates$boro_ct201
race_merged2 <- race_merged[rm,]
# Get the W matrix
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,rates$stop.clothing)

### Moran's I
moran.test(rates$stop.clothing,lws, zero.policy = T)
moran.mc(rates$stop.clothing,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(rates$stop.clothing,lws, zero.policy = T)
geary.mc(rates$stop.clothing,lws,nsim=999, zero.policy = T)

## B. Queen Weighting
### Pre-process data
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,rates$stop.clothing)

### Moran's I
moran.test(rates$stop.clothing,lws, zero.policy = T)
moran.mc(rates$stop.clothing,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(rates$stop.clothing,lws, zero.policy = T)
geary.mc(rates$stop.clothing,lws,nsim=999, zero.policy = T)

# II. Furtive Movements
## A. Rook Weighting
### Pre-process data
# Get the W matrix
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,rates$stop.furtive)

### Moran's I
moran.test(rates$stop.furtive,lws, zero.policy = T)
moran.mc(rates$stop.furtive,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(rates$stop.furtive,lws, zero.policy = T)
geary.mc(rates$stop.furtive,lws,nsim=999, zero.policy = T)

## B. Queen Weighting
### Pre-process data
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,rates$stop.clothing)

### Moran's I
moran.test(rates$stop.furtive,lws, zero.policy = T)
moran.mc(rates$stop.furtive,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(rates$stop.furtive,lws, zero.policy = T)
geary.mc(rates$stop.furtive,lws,nsim=999, zero.policy = T)
