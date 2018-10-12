#############################
###### 4. Local Tests #######
#############################




# A. Rook Weighting
PA.nb <- poly2nb(PA.utm,queen=FALSE)
PA.lw <- nb2listw(PA.nb)

moran.loc.rook <-localmoran(PA.agg$adj.rate,PA.lw,p.adjust.method="fdr") 
shades <- shading(c(0.05),cols=c(2,8))
choropleth(PA.utm,moran.loc[,"Pr(z > 0)"],shades)

# B. Queen Weighting
PA.nb <- poly2nb(PA.utm,queen=TRUE)
PA.lw <- nb2listw(PA.nb)

moran.loc.queen <-localmoran(PA.agg$adj.rate,PA.lw,p.adjust.method="fdr") 
shades <- shading(c(0.05),cols=c(2,8))
choropleth(PA.utm,moran.loc[,"Pr(z > 0)"],shades)