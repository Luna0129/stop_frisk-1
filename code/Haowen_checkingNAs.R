#check NAs for merged data 

na.merged <- merged@data[drops,] #from 5_relative_probabilities
require(sp) 
na.check <- merge(CT.boundaries,na.merged, by="boro_ct201", all.x=FALSE) #15 cts
leaflet(na.check) %>%
  addTiles()%>%
  addPolygons(color = "#444444", weight = 0.4, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5) 
#looks problematic
na <- results[drops,]
head(na) #not NAs 

#so I breaked things down and checked under each local moran matrix, eg. 
na <- moran.loc.queen %>% 
  as.data.frame() %>%
  mutate(boro_ct201 = race_merged2$boro_ct201) %>%
  filter(is.na(moran.loc.rook[,5]))
na.check <- merge(CT.boundaries,na, by="boro_ct201", all.x=FALSE) 
plot(na.check) #those are clearly islands 

#I doubt somehow something went wrong in the merging. What if we identify the NAs before merging? 
results2 <- results %>% 
  mutate(boro_ct201 = race_merged2$boro_ct201) 
drops <- apply(is.na(results2[, c('clothing.rook', 'clothing.queen', 'furtive.rook', 'furtive.queen')]), 1, any)
na <- results2[drops,]
check.merge <- merge(CT.boundaries,na, by="boro_ct201", all.x=FALSE) 
str(check.merge, max.level = 2) #3 cts
plot(check.merge) #looks right

#first drop the NAs and then merge, clean version
results$boro_ct201 <- race_merged2$boro_ct201
drops <- apply(is.na(results[, c('clothing.rook', 'clothing.queen', 'furtive.rook', 'furtive.queen')]), 1, any)
results.keep <- results[!drops,] #2150 cts, dropped 3 islands
merged <- merge(race_merged2, results.keep, by='boro_ct201',all.x=FALSE) 
#sum(is.na(merged@data$clothing.rook)) check again, 0 
#sum(is.na(merged@data$clothing.queen))
#sum(is.na(merged@data$furtive.rook))
#sum(is.na(merged@data$furtive.queen))