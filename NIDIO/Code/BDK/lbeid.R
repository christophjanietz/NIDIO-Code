################################################################################
# BEID CHANGE NETWORK BASED ON BDK
################################################################################
# Project: NIDIO
# Author: Christoph Janietz (c.janietz@rug.nl)
# Last update: 08-12-2025
################################################################################

library(haven)
library(readxl)
library(ggplot2)
library(tidyverse)
library(igraph)

# Load data
beid_networks <- read_dta("H:/bdk_lbeid_2007_2024.dta")

# Prepare adjacency list (all years)
net <- beid_networks %>%
    select(-c(year))
names(net) <- c('from', 'to')
  
# Extract components
netcomponents <- components(graph_from_data_frame(net), mode="weak")
  
# Save as data frame 
g <- with(netcomponents,
          data.frame( beid = names(membership),
                      lbeid = membership,
                      N = csize[membership]
          )
  ) %>% 
    arrange(lbeid)
rownames(g) <- NULL
  
filename <- "H:/bdk_lbeid.dta"
  
write_dta(g, filename)
