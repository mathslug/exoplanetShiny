library(dplyr)
library(ggplot2)
library(shiny)


raw_data = read.csv("data/kepler.csv")

use_data = raw_data %>% filter(., planet_status == "Confirmed") %>%
  select(., star_name, star_distance, planet_name = X..name, detection_type,
         planet_mass = mass,planet_radius = radius,
         discovery_year = discovered, temp_calculated, temp_measured)

#add one missing discovery year. Earliest publication I could find regarding
#this object is in 2018.
use_data[use_data$planet_name == "OGLE-2017-BLG-1434L b", "discovery_year"] = 2018

#data for scatterplots
scatter_data = use_data %>% select(., discovery_year, detection_type,
                                   planet_mass)