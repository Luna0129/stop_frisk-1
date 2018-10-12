###############################
####### 3. Global Tests #######
###############################
library(rgdal)
library(sp)
library(spdep)
library(spatstat)

# Load CT rates data
# "rates"
load('data/rates.rdata')

# Load CT SpatialPolygons
# "ct.sp"
load('data/ct.sp.rdata')

# Unit testing Moran's I (mc)
nbs <- poly2nb(merged.sp)
lws <- nb2listw(nbs, zero.policy=TRUE)
moran.mc(rates$stop.clothing, lws, nsim=999, zero.policy=TRUE)
