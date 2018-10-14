

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
            title = "Use the slider to view all exoplanets discovered through the selected
            year for which there are sufficient data.",
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = TRUE,
            sliderInput("slider1", "Select Year", min(use_data$discovery_year),
                        max(use_data$discovery_year), 2018, ticks = FALSE,
                        round = TRUE, sep = '', width = '100%'))),
        
        #second row, first scatter dist, mass graph
        fluidRow(
          box(plotOutput("scatter1", height = 450), width = '90%')
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