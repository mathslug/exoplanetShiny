library(dplyr)
library(ggplot2)
library(shiny)
library(DT)
library(shinydashboard)
library(scales)
library(googleVis)

#Project by John to explore capabilities of R Shiny
#Data from exoplanet Encyclopedia: http://exoplanet.eu/catalog/
#Source for orbital math:
#https://www.math.ubc.ca/~cass/courses/m309-01a/orbits.pdf


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



#Get data for orbit graph
orbit_data = raw_data %>% select(., star_name, star_mass,
                                 planet_name = X..name,
                                 period = orbital_period,
                                 semi_major_axis,
                                 eccentricity, detection_type) %>%
  filter(., rowSums(is.na(.)) == 0) %>%
  #Use formula relating eccentricity to major and minor axes of ellipse
  #find distance from center of ellipse to star (foci)
  mutate(., semi_minor_axis = semi_major_axis * sqrt(1 - eccentricity ^ 2),
         center_to_star = semi_major_axis * eccentricity)
  

#funtion for use in finding eccentric anomaly for obital calculations.
#will return zero if eccentric anomaly is correct
ecc_anom_err = function(ecc_anom, mean_anom, eccen) {
  return(mean_anom - ecc_anom + eccen * sin(ecc_anom))
}






