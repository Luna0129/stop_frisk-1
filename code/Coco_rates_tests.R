library(sf)
library(sp)
library(spdep)
library(spatstat)

load('data/ct_data.rdata')

#rate calculations
race_merged@data$rate.clothing <- race_merged@data$stopped.clothing/race_merged@data$total.stops
race_merged@data$rate.furtive <- race_merged@data$stopped.furtive/race_merged@data$total.stops
race_merged@data$rate.clothing[is.na(race_merged@data$rate.clothing)] <- 0
race_merged@data$rate.furtive[is.na(race_merged@data$rate.furtive)] <- 0


#global and local tests with queen continuity
NY.nb <- poly2nb(race_merged, queen = TRUE)
NY.lw <- nb2listw(NY.nb, zero.policy = TRUE)

moran.test(race_merged@data$rate.clothing, NY.lw, zero.policy = TRUE)
moran.mc(race_merged@data$rate.clothing, NY.lw, nsim=999, zero.policy = TRUE)

geary.test(race_merged@data$rate.clothing, NY.lw, zero.policy = TRUE)
geary.mc(race_merged@data$rate.clothing, NY.lw, nsim=999, zero.policy = TRUE)

moran.test(race_merged@data$rate.furtive, NY.lw, zero.policy = TRUE)
moran.mc(race_merged@data$rate.furtive, NY.lw, nsim=999, zero.policy = TRUE)

geary.test(race_merged@data$rate.furtive, NY.lw, zero.policy = TRUE)
geary.mc(race_merged@data$rate.furtive, NY.lw, nsim=999, zero.policy = TRUE)


moran.loc.queen <-localmoran(race_merged@data$rate.clothing, NY.lw,p.adjust.method="fdr", zero.policy = T) 
shades <- shading(c(0.05),cols=c(2,8))
choropleth(race_merged,moran.loc.queen[,"Pr(z > 0)"],shades)


