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

#dropping census tracts with total pop of 0 and total stops of 0
empty <- race_merged@data[race_merged@data$total_pop == 0 & race_merged@data$total.stops == 0
                          | is.na(race_merged@data$total_pop),]
rm <- !(race_merged$boro_ct201 %in% empty$boro_ct201)
race_merged3 <- race_merged[rm,]

#global and local tests with queen continuity
set.seed(2090)
NY.nb <- poly2nb(race_merged3, queen = TRUE)
NY.lw <- nb2listw(NY.nb, zero.policy = TRUE)

moran.test(race_merged3@data$rate.clothing, NY.lw, zero.policy = TRUE)
moran.mc(race_merged3@data$rate.clothing, NY.lw, nsim=999, zero.policy = TRUE)

geary.test(race_merged3@data$rate.clothing, NY.lw, zero.policy = TRUE)
geary.mc(race_merged3@data$rate.clothing, NY.lw, nsim=999, zero.policy = TRUE)

moran.test(race_merged3@data$rate.furtive, NY.lw, zero.policy = TRUE)
moran.mc(race_merged3@data$rate.furtive, NY.lw, nsim=999, zero.policy = TRUE)

geary.test(race_merged3@data$rate.furtive, NY.lw, zero.policy = TRUE)
geary.mc(race_merged3@data$rate.furtive, NY.lw, nsim=999, zero.policy = TRUE)


moran.loc.queen <-localmoran(race_merged3@data$rate.clothing, NY.lw,p.adjust.method="fdr", zero.policy = T) 
shades <- shading(c(0.05),cols=c(2,8))
choropleth(race_merged3,moran.loc.queen[,"Pr(z > 0)"],shades)

moran.loc.queen <-localmoran(race_merged3@data$rate.furtive, NY.lw,p.adjust.method="fdr", zero.policy = T) 
shades <- shading(c(0.05),cols=c(2,8))
choropleth(race_merged3,moran.loc.queen[,"Pr(z > 0)"],shades)



