#############################
###### 4. Local Tests #######
#############################

library(sf)
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
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.rook <-localmoran(race_merged2@data$rate.clothing, lws, p.adjust.method="fdr", zero.policy = T)
clothing.rook <- moran.loc.rook[, 5]
shades <- shading(c(0.05), cols=c(2,8))
png("Clothing.rooklocal.png")
choropleth(race_merged2, moran.loc.rook[,"Pr(z > 0)"], shades)
title("Rook's Continuity", cex=.8)
dev.off()
## B. Queen Weighting
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.queen <-localmoran(race_merged2@data$rate.clothing, lws, p.adjust.method="fdr", zero.policy = T)
clothing.queen <- moran.loc.queen[, 5]
shades <- shading(c(0.05), cols=c(2,8))
png("Clothing.queenlocal.png")
choropleth(race_merged2, moran.loc.queen[,"Pr(z > 0)"], shades)
title("Queen's Continuity", cex=.8)
dev.off()

# II. Furtive Movements
## A. Rook Weighting
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.rook <-localmoran(race_merged2@data$rate.furtive, lws, p.adjust.method="fdr", zero.policy = T)
furtive.rook <- moran.loc.rook[, 5]
shades <- shading(c(0.05),cols=c(2,8))
png("Furtive.rooklocal.png")
choropleth(race_merged2, moran.loc.rook[,"Pr(z > 0)"], shades)
title("Rook's Continuity", cex=.8)
dev.off()
## B. Queen Weighting
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.queen <-localmoran(race_merged2@data$rate.furtive, lws, p.adjust.method="fdr", zero.policy = T)
furtive.queen <- moran.loc.queen[, 5]
shades <- shading(c(0.05), cols=c(2,8))
png("Furtive.queenlocal.png")
choropleth(race_merged2, moran.loc.queen[,"Pr(z > 0)"], shades)
title("Queen's Continuity",cex=.8)
dev.off()

# Save outputs
results <- data.frame(clothing.rook, clothing.queen, furtive.rook, furtive.queen)

save(results, file='data/local_moran_tests.rdata')
