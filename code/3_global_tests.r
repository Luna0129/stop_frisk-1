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
    lws <- nb2list2(nbs)

    if (test == 'moran') {
        return(moran.mc(rateVar, lws, nsim=nsim))
    } else {
        return(geary.mc(rateVar, lws, nsim=nsim))
    }
}


# A. Rook Weighting
# Pre-process data
rates <- spTransform(PA.latlong, st_crs(rates))
choropleth(PA.utm,PA.agg$rate)

# Moran's I
PA.nb <- poly2nb(PA.utm,queen=FALSE)
PA.lw <- nb2listw(PA.nb)
moran.test(PA.agg$adj.rate,PA.lw)
moran.mc(PA.agg$adj.rate,PA.lw,nsim=999)

# Geary's c
geary.test(PA.agg$adj.rate,PA.lw)
geary.mc(PA.agg$adj.rate,PA.lw,nsim=999)

# B. Queen Weighting
# Pre-process data
PA.utm <- spTransform(PA.latlong,CRS("+init=epsg:3724 +units=km"))
choropleth(PA.utm,PA.agg$rate)

# Moran's I
PA.nb <- poly2nb(PA.utm,queen=TRUE)
PA.lw <- nb2listw(PA.nb)
moran.test(PA.agg$adj.rate,PA.lw)
moran.mc(PA.agg$adj.rate,PA.lw,nsim=999)

# Geary's c
geary.test(PA.agg$adj.rate,PA.lw)
geary.mc(PA.agg$adj.rate,PA.lw,nsim=999)