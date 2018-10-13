library(shinydashboard)
library(googleVis)


dashboardPage(
  dashboardHeader(title = "Exoplanet Search"),
  
  dashboardSidebar(
    collapsed = TRUE,
    
    sidebarUserPanel("by John", image = "earth.jpg"),
    
    #initialize tabs on sidebar
    sidebarMenu(
      menuItem("Discoveries", tabName = "discovs",
               icon = icon("th-large", lib = "glyphicon")),
      menuItem("Data", tabName = "data", icon = icon("database"))),
    
    checkboxGroupInput("checkGroup",
                       h3("Detection Methods"),
                       choices = unique(use_data$detection_type),
                       selected = unique(use_data$detection_type))
    ),
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    #Make multiple tab output pages
    tabItems(
      
      #Make first page, with graphs by discovery year
      tabItem(
        tabName = "discovs",
        
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
      ),
      
      #tab to view data directly
      tabItem(tabName = "data",
              fluidRow(
                checkboxGroupInput("selected",
                                   h3("Variables"),
                                   inline = TRUE,
                                   choices = unique(
                                     names(use_data))[c(-3, -4)])),
              fluidRow(box(DT::dataTableOutput("table"), width = 12))
      )
      
    )
  )
)