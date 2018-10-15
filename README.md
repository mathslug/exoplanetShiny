# Exoplanet Search

Project to explore the capabilities of R Shiny for NYC Data Science Academy 2018.
This webapp allows you to explore the relationship between several variables in the
Exoplanet Encyclopedia Dataset of confirmed exoplanets (planets outside earth's
solar system).
You can:
-See mass and distance away of discoveries by year and discovery method.
-See popularity of different discovery methods over time.
-Visualize the orbits of exoplanets, including eccentricity.
-Directly view the data.

## Getting Started

See the webapp at: https://mathslug.shinyapps.io/exoplanetShiny/
Or, pull this repo and run it using R Studio.
The data can be found: http://exoplanet.eu/catalog/

### Prerequisites

Flash needed to run webapp.

To run natively:

R environement, packages.
library(dplyr)
library(ggplot2)
library(shiny)
library(DT)
library(shinydashboard)
library(scales)
library(googleVis)

## Built With

* R Studio

## Authors

* **John Bentley**  - [mathSlug](https://github.com/mathSlug)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## Acknowledgments

* NYC Data Science Academy
* https://www.math.ubc.ca/~cass/courses/m309-01a/orbits.pdf

