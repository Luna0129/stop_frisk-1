#############################
###### 4. Local Tests #######
#############################



# I. Clothing
## A. Rook Weighting
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.rook <-localmoran(race_merged2@data$rate.clothing,lws,p.adjust.method="fdr", zero.policy = T) 
shades <- shading(c(0.05),cols=c(2,8))
png("Clothing.rooklocal.png")
choropleth(race_merged2,moran.loc.rook[,"Pr(z > 0)"],shades)
title("Rook's Continuity",cex=.8)
dev.off()
## B. Queen Weighting
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.queen <-localmoran(race_merged2@data$rate.clothing,lws,p.adjust.method="fdr", zero.policy = T) 
shades <- shading(c(0.05),cols=c(2,8))
png("Clothing.queenlocal.png")
choropleth(race_merged2,moran.loc.queen[,"Pr(z > 0)"],shades)
title("Queen's Continuity",cex=.8)
dev.off()

# II. Furtive Movements
## A. Rook Weighting
set.seed(2090)
nbs <- poly2nb(race_merged2, queen = F)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.rook <-localmoran(race_merged2@data$rate.furtive,lws,p.adjust.method="fdr", zero.policy = T) 
shades <- shading(c(0.05),cols=c(2,8))
png("Furtive.rooklocal.png")
choropleth(race_merged2,moran.loc.rook[,"Pr(z > 0)"],shades)
title("Rook's Continuity",cex=.8)
dev.off()
## B. Queen Weighting
nbs <- poly2nb(race_merged2, queen = T)
lws <- nb2listw(nbs, zero.policy = T)

moran.loc.queen <-localmoran(race_merged2@data$rate.furtive,lws,p.adjust.method="fdr", zero.policy = T) 
shades <- shading(c(0.05),cols=c(2,8))
png("Furtive.queenlocal.png")
choropleth(race_merged2,moran.loc.queen[,"Pr(z > 0)"],shades)
title("Queen's Continuity",cex=.8)
dev.off()