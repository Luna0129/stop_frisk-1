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
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)
choropleth(race_merged2,rates$stop.clothing)

### Moran's I
moran.test(rates$stop.clothing,lws, zero.policy = T)
moran.mc(rates$stop.clothing,lws,nsim=999, zero.policy = T)

### Geary's c
geary.test(PA.agg$adj.rate,PA.lw)
geary.mc(PA.agg$adj.rate,PA.lw,nsim=999)

## B. Queen Weighting
### Pre-process data
PA.utm <- spTransform(PA.latlong,CRS("+init=epsg:3724 +units=km"))
choropleth(PA.utm,PA.agg$rate)

### Moran's I
PA.nb <- poly2nb(PA.utm,queen=TRUE)
PA.lw <- nb2listw(PA.nb)
moran.test(PA.agg$adj.rate,PA.lw)
moran.mc(PA.agg$adj.rate,PA.lw,nsim=999)

### Geary's c
geary.test(PA.agg$adj.rate,PA.lw)
geary.mc(PA.agg$adj.rate,PA.lw,nsim=999)

# II. Furtive Movements