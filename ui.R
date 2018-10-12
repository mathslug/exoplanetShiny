library(shinydashboard)
library(googleVis)


dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(
        width = 12,
        title = "Year of Data",
        sliderInput("slider1", "Select Year", min(use_data$discovery_year),
                    max(use_data$discovery_year), 2000, ticks = FALSE,
                    round = TRUE, sep = '', width = '100%'))),
    fluidRow(  
      box(plotOutput("bar1", height = 250))
    )
  )
)