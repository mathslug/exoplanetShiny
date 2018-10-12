library(shinydashboard)
library(googleVis)


dashboardPage(
  dashboardHeader(title = "Exoplanet Search"),
  
  dashboardSidebar(
    collapsed = TRUE,
    
    sidebarUserPanel("by John", image = "earth.jpg"),
    
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Data", tabName = "data", icon = icon("database")))
    ),
  
  dashboardBody(
    #Create first row, the year-slider
    fluidRow(
      box(
        width = 12,
        title = "Visualize the New and Total Exoplanet Discoveries by Year
          and Detection Method",
        solidHeader = TRUE,
        collapsible = TRUE,
        collapsed = TRUE,
        sliderInput("slider1", "Select Year", min(use_data$discovery_year),
                    max(use_data$discovery_year), 2018, ticks = FALSE,
                    round = TRUE, sep = '', width = '100%'))),
    
    #second row, two graphs
    fluidRow(  
      box(plotOutput("bar1", height = 400), background = "black"),
      box(plotOutput("scatter1", height = 400))
    )
  )
)