dashboardPage(
  dashboardHeader(title = "Exoplanet Search"),
  
  dashboardSidebar(
    collapsed = TRUE,
    
    sidebarUserPanel('by John', image = "earth.jpg"),
    
    #initialize tabs on sidebar
    sidebarMenu(
      menuItem("Planet Scatterplot", tabName = "discovs",
               icon = icon("sort", lib = "glyphicon")),
      menuItem("Discovery Timeline", tabName = "props",
               icon = icon("th-large", lib = "glyphicon")),
      menuItem("Orbit Visualization", tabName = "orbits", 
               icon = icon("refresh", lib = "glyphicon")),
      menuItem("Raw Data", tabName = "data", icon = icon("database"))),
    
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
            collapsed = FALSE,
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
                                   h3("Select Additional Columns to Show"),
                                   inline = TRUE,
                                   choices = unique(
                                     names(use_data))[c(-3, -4)])),
              fluidRow(box(dataTableOutput("table"), width = 12, footer = "Data from
                           The Exoplanet Encyclopedia, 2018"))
              ),
      
      tabItem(tabName = "props",
            fluidRow(box(plotOutput("bar2", height = 250), height = 250, width = '100%')),
            fluidRow(box(plotOutput("bar1", height = 250), height = 250, width = '100%'))
            ),
      
      tabItem(tabName = "orbits",
              fluidRow(box(title = "Visualize Orbits of Exoplanet Star Systems",
                           footer = "Time measured in earth days. Position calculated 
using Kepler's laws. Distance shown in AUs. (1 AU = average distance from the Earth to 
the Sun.) All planets shown in a reference frame with +x axis collinear with orbit 
perineum in multi-planet systems may not be accurate relative to each other."),
                box(selectInput("star_system",
                                   label = "Select Planetary System",
                                   choices = unique(orbit_data$star_name),
                                   selected = "HD 10180"
                                   ))),
              fluidRow(htmlOutput("orbit")), 
              fluidRow(box(dataTableOutput("orbitTable"), width = 12))
              )
      
      )
  )
)