

function(input, output) {
  
  output$scatter1 = renderPlot({
    #organize data, only include planets with known mass
    scatter1data = scatter_data %>%
      filter(., discovery_year <= input$slider1, !is.na(planet_mass),
             !is.na(star_distance)) %>%
      filter(., detection_type %in% input$checkGroup)

    
    #create scatterplot of all year's discoveries thru selected years
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
  output$table <- DT::renderDataTable({
    datatable(filter(select(use_data,
                            append(c("planet_name", "detection_type"),
                                   input$selected)),
                     detection_type %in% input$checkGroup),
              rownames=FALSE) %>% 
      formatStyle(., input$selected, background="skyblue", fontWeight='bold')
  })
  
}