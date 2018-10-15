function(input, output) {
  
  #create scatterplot of all year's discoveries thru selected years
  output$scatter1 = renderPlot({
    #organize data, only include planets with known mass
    scatter1data = scatter_data %>%
      filter(., discovery_year <= input$slider1, !is.na(planet_mass),
             !is.na(star_distance)) %>%
      filter(., detection_type %in% input$checkGroup)

    ggplot(scatter1data, aes(x = star_distance, y = planet_mass,
                             color = detection_type)) +
      geom_point(size = 3) +
      scale_color_manual(values = color_map) +
      theme(plot.subtitle = element_text(vjust = 1),
            plot.caption = element_text(vjust = 1),
            plot.title = element_text(hjust = 0.5, size = 20),
            legend.title = element_text(size = 9),
            plot.background = element_rect(fill = "ghostwhite"),
            legend.key = element_rect(fill = "ghostwhite"), 
            legend.background = element_rect(fill = "ghostwhite"),
            legend.position = "bottom",
            legend.direction = "horizontal") +
      guides(colour = guide_legend(nrow = 1)) +
      labs(title = paste("Discoveries Through", input$slider1),
           x = "Distance of Exoplanet Star from Sun (Parsecs)",
           y = "Planet Mass (Jupiter Masses)",
           colour = NULL) +
      theme(axis.text=element_text(size=11),
            axis.title=element_text(size=12,face="bold")) +
      theme(panel.grid.major = element_line(linetype = "blank"),
            panel.grid.minor = element_line(linetype = "blank"),
            panel.background = element_rect(fill = "ghostwhite")) +
      theme(panel.background = element_rect(fill = "white")) +
      theme(legend.text = element_text(size = 12)) +
      scale_x_log10(name = waiver(), breaks = c(1,10,100,1000,10000),
                    limits = c(1,13000)) +
      scale_y_log10(name = waiver(), breaks = c(1e-4, 1e-1, 1e+2),
                    limits = c(1e-6, 2e+2))
    })
  
  # show data using DataTable
  output$table = renderDataTable({
    datatable(filter(select(use_data,
                            append(c("planet_name", "detection_type"),
                                   input$selected)),
                     detection_type %in% input$checkGroup),
              rownames=FALSE) %>% 
      formatStyle(., input$selected, background="skyblue", fontWeight='bold')
  })
  
  
  #plot of discoveries by method
  output$bar1 = renderPlot({
    #filter by selected year
    bar1data = scatter_data %>%
      filter(., detection_type %in% input$checkGroup)
    
    ggplot(bar1data, aes(x = detection_type, fill = detection_type)) +
      geom_bar() +
      theme(plot.subtitle = element_text(vjust = 1), 
            plot.caption = element_text(vjust = 1), 
            panel.grid.major = element_line(colour = "white", linetype = "blank"),
            panel.grid.minor = element_line(linetype = "blank"), 
            axis.title = element_text(size = 10, colour = "white"),
            axis.text.x = element_text(size = 9, colour = "white", vjust = 0.75,
                                       angle = 45),
            axis.text.y = element_text(colour = "white"),
            plot.title = element_text(size = 13, colour = "white", hjust = .5),
            panel.background = element_rect(fill = "black"),
            plot.background = element_rect(fill = "black")) +
      labs(title = "Planets Discovered by Method",
           x = "Detection Method", y = "Planet Count", colour = "White") +
      scale_fill_manual(values = color_map)
  })
  
  
  
  
  #make graph of the propertion of detection methods / year
  output$bar2 = renderPlot({
    bar2data = scatter_data %>%
      filter(., detection_type %in% input$checkGroup) %>%
      select(., detection_type, discovery_year) %>%
      group_by(., discovery_year, detection_type) %>%
      summarise(., discoveries = n()) %>%
      mutate(., prop = 100 * discoveries / sum(discoveries))
      
    ggplot(bar2data, aes(x = discovery_year, y = prop, fill = detection_type)) +
      geom_col(position = "stack") +
      theme(plot.subtitle = element_text(vjust = 1), 
            plot.caption = element_text(vjust = 1), 
            panel.grid.major = element_line(colour = "white", linetype = "blank"),
            panel.grid.minor = element_line(linetype = "blank"), 
            axis.title = element_text(size = 10, colour = "white"),
            axis.text.x = element_text(size = 9, colour = "white", vjust = 0.75,
                                       angle = 45),
            axis.text.y = element_text(colour = "white"),
            plot.title = element_text(size = 13, colour = "white", hjust = .5),
            panel.background = element_rect(fill = "black"),
            plot.background = element_rect(fill = "black")) +
      labs(title = "Breakdown of Discovery Method by Year",
           x = "Year", y = "Percentage",
           colour = "White") + theme(axis.text = element_text(size = 11), 
    legend.position = "none") +
      scale_fill_manual(values = color_map)
      
  })
  
  #Create orbit-motion plot
  output$orbit = renderGvis({
    days_to_show = 1899
    
    #construct data for orbital moving plot
    #this data-gathering code is not strictly necessary but makes the code
    #easier to follow
    star = input$star_system
    this_orbit_data = orbit_data %>% filter(., star_name == star) %>%
      filter(., detection_type %in% input$checkGroup) %>%
      select(., planet_name, period, semi_major_axis, semi_minor_axis,
             eccentricity, center_to_star)
    
    days = (0:days_to_show)
    
    #initialize the system by chosing the star as the origin
    sys_pos = data_frame(obj_name = rep(star, days_to_show + 1),
                          days, x_pos = rep(0, days_to_show + 1),
                          y_pos = rep(0, days_to_show + 1))
    
    for(planet in this_orbit_data$planet_name) {
      #get info needed to calculate planet motion, for later ease of access
      period = this_orbit_data[this_orbit_data$planet_name == planet, "period"]
      eccentricity = this_orbit_data[this_orbit_data$planet_name == planet,
                                     "eccentricity"]
      semi_major_axis = this_orbit_data[this_orbit_data$planet_name == planet,
                                        "semi_major_axis"]
      semi_minor_axis = this_orbit_data[this_orbit_data$planet_name == planet,
                                        "semi_minor_axis"]
      center_to_star = this_orbit_data[this_orbit_data$planet_name == planet,
                                       "center_to_star"]
      
      #find mean anaomaly for each day, necessary to find
      #eccentric anomaly for Kepler equ
      mean_anomaly = 2 * pi * days / period
      
      #Find zero of ecc_anom_err for each mean anomaly to find eccentric anomaly
      eccentric_anomaly = mean_anomaly
      for(i in days + 1) {
        this_ecc_anom_err = function(ecc_anom) {
          return(ecc_anom_err(ecc_anom, mean_anomaly[i], eccentricity))
        }

        eccentric_anomaly[i] = uniroot(this_ecc_anom_err,
                                       interval = c(mean_anomaly[i] - 2,
                                                    mean_anomaly[i] + 2))$root
        }
      
      #compute end-of-day x and y positions, assuming star is +x foci and
      #major axis is aligned with x axis.
      x_pos = semi_major_axis * cos(eccentric_anomaly) - center_to_star
      y_pos = semi_minor_axis * sin(eccentric_anomaly)
      
      #create data from for newly-calculated planet data.
      planet_pos = data_frame(obj_name = rep(planet, days_to_show + 1),
                           days, x_pos, y_pos)
      
      #add to existing data set
      sys_pos = rbind(sys_pos, planet_pos)
      
    }
    
    #configure proper data types
    sys_pos = as.data.frame(sys_pos)
    sys_pos$obj_name = as.factor(sys_pos$obj_name)
    sys_pos$days = as.numeric(sys_pos$days+100)
    
    #set parameters for motion chart
    State = '
    {"colorOption":"_UNIQUE_COLOR"}
    '
    
    
    #create motion-plot
    gvisMotionChart(sys_pos, idvar = "obj_name", timevar = "days",
                    xvar = "x_pos", yvar = "y_pos",
                    options = list(showTrails = TRUE, state=State))
    
  })
  
}