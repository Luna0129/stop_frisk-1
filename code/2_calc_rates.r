#######################################
########## 2. Calculate Rates #########
#######################################
require(sf)
require(dplyr)

# LOAD CLEANED DATA
load('data/sqf2011_ct.rdata')
sqf.ct <- as_tibble(sqf.ct)

# CALCULATE RATES
cols.stopped <- names(sqf.ct)[grep('^stopped', names(sqf.ct))]
stopped.total <- apply(sqf.ct[cols.stopped], 1, sum)

sqf.ct$stopped.total <- stopped.total

# Rates
rates <- sqf.ct %>%
    group_by(boro_ct201) %>%
    summarise(stop.clothing=sum(stopped.bc.clothing)/sum(stopped.total),
        stop.furtive=sum(stopped.bc.furtive)/sum(stopped.total),
        total_stopped=mean(stopped.total))


