library(dplyr)
library(ggplot2)
library(shiny)
library(DT)
library(shinydashboard)
library(scales)


raw_data = read.csv("data/exoplanet.eu_catalog.csv")

use_data = raw_data %>% filter(., planet_status == "Confirmed") %>%
  select(., star_name, star_distance, planet_name = X..name, detection_type,
         planet_mass = mass,planet_radius = radius,
         discovery_year = discovered, temp_calculated, temp_measured)

#add one missing discovery year. Earliest publication I could find regarding
#this object is in 2018.
use_data[use_data$planet_name == "OGLE-2017-BLG-1434L b",
         "discovery_year"] = 2018

#Rename Primary Transit, TTV so it makes more sense.
levels(use_data$detection_type)[levels(use_data$detection_type)==
                                  "Primary Transit, TTV"] = "Primary Transit & TTV"


#data for scatterplots
scatter_data = use_data %>% select(., discovery_year, detection_type,
                                   planet_mass, star_distance)

#Set color mapping for consistency across graph changes
color_map = c("#0000ff", "#55ffff", "#FF0000",
              "#930000", "#065535", "#966842",
              "#eedc31", "#7937fc", "#26ff3f")

names(color_map) = unique(use_data$detection_type)





