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
sqf.ct  <- sqf.ct %>% group_by(boro_ct201) %>% mutate(total = length(year))

# Rates
rates <- sqf.ct %>%
    group_by(boro_ct201) %>%
   summarise(stop.clothing=sum(stopped.bc.clothing)/mean(total),
        stop.furtive=sum(stopped.bc.furtive)/mean(total),
        total_stopped=mean(total))


