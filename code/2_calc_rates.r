#######################################
########## 2. Calculate Rates #########
#######################################
require(dplyr)

# LOAD CLEANED DATA
load('data/final.rdata')

# CALCULATE RATES
sqf.ct.grp  <- as.data.frame(final) %>% group_by(boro_ct201) %>% mutate(total = length(year))

# Rates
rates <- sqf.ct.grp %>%
    group_by(boro_ct201) %>%
    summarise(stop.clothing=sum(stopped.bc.clothing)/mean(total),
        stop.furtive=sum(stopped.bc.furtive)/mean(total),
        total_stopped=mean(total),
        per_white=mean(per_white), per_black=mean(per_black), per_nat.amer=mean(per_nat.amer), per_asia=mean(per_asia), per_whisp=mean(per_whisp), per_bhisp=mean(per_bhisp), per_other=mean(per_other))
# This produces a data frame of 2136 tracts. However, tract 0 is the 19 points that
# did not occur in any tract, so we will drop this row.
rates <- rates[-1,]

# Save the rates data
save(rates, file='data/rates.rdata')
