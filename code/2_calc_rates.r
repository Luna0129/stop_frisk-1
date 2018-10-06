#######################################
########## 2. Calculate Rates #########
#######################################


# A. Clothing
stop.clothing <- sffinal[sffinal$stopped.bc.clothing == TRUE,]


# B. Furtive Movements
stop.furtive <- sffinal[sffinal$stopped.bc.furtive == TRUE, ]


# C. Stops vs. Frisks? because of Clothing/Furtive
#could look at where stops because of a certain variable also turn into 
#frisks and how that clusters

