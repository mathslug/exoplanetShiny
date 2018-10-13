library(dplyr)
library(ggplot2)
library(shiny)
library(DT)


raw_data = read.csv("data/kepler.csv")

use_data = raw_data %>% filter(., planet_status == "Confirmed") %>%
  select(., star_name, star_distance, planet_name = X..name, detection_type,
         planet_mass = mass,planet_radius = radius,
         discovery_year = discovered, temp_calculated, temp_measured) %>%
  mutate(., log_planet_mass = log(planet_mass))

#add one missing discovery year. Earliest publication I could find regarding
#this object is in 2018.
use_data[use_data$planet_name == "OGLE-2017-BLG-1434L b",
         "discovery_year"] = 2018

#Confirmed the two planets with "Primary Transit, TTV" detection method were
#first discovered with Primary Transit. Clean data to replect this and
#cut down on detection types
use_data[use_data$detection_type == "Primary Transit, TTV",
         "detection_type"] = "Primary Transit"

#data for scatterplots
scatter_data = use_data %>% select(., discovery_year, detection_type,
                                   planet_mass, log_planet_mass)