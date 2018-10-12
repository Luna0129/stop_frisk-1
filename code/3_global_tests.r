###############################
####### 3. Global Tests #######
###############################


# A. Rook Weighting
# Pre-process data
PA.utm <- spTransform(PA.latlong,CRS("+init=epsg:3724 +units=km"))
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