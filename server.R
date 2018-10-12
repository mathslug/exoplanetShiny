function(input, output) {
  
  output$bar1 = renderPlot({
    #filter by selected year
    bar1data = scatter_data %>% filter(., discovery_year == input$slider1)

    #produce plot
    ggplot(bar1data, aes(x = detection_type)) + geom_bar() + theme(plot.subtitle = element_text(vjust = 1), 
    plot.caption = element_text(vjust = 1), 
    panel.grid.major = element_line(colour = "white", 
        linetype = "blank"), panel.grid.minor = element_line(linetype = "blank"), 
    axis.title = element_text( 
        size = 9, colour = "white"), axis.text.x = element_text( 
        size = 8, colour = "white", vjust = 0.75, 
        angle = 45), axis.text.y = element_text( 
        colour = "white"), plot.title = element_text( 
        size = 13, colour = "white", hjust = .5), panel.background = element_rect(fill = "black"), 
    plot.background = element_rect(fill = "black")) +labs(title = paste("Number of Planets Discovered in", input$slider1), 
    x = "Detection Method", y = "Planet Count", 
    colour = "White")
  })
  
  
  output$scatter1 = renderPlot({
    #organize data, only include planets with known mass
    scatter1data = scatter_data %>% filter(., discovery_year <= input$slider1,
                                           !is.na(planet_mass))
    
    #create plot
    ggplot(scatter1data, aes(x = discovery_year, y = planet_mass, color = detection_type)) +
      geom_point(position = 'jitter') + theme(plot.subtitle = element_text(vjust = 1), 
    plot.caption = element_text(vjust = 1), 
    plot.title = element_text(hjust = 0.5), 
    legend.title = element_text(size = 8), 
    plot.background = element_rect(fill = "ghostwhite"), 
    legend.key = element_rect(fill = "ghostwhite"), 
    legend.background = element_rect(fill = "ghostwhite"), 
    legend.position = "bottom", legend.direction = "horizontal") +labs(title = paste("Discoveries Through", input$slider1, "Year by Method"), 
    x = "Year of Discovery", y = "Planet Mass (M_Jup)", 
    colour = NULL) + theme(panel.grid.major = element_line(linetype = "blank"), 
    panel.grid.minor = element_line(linetype = "blank"), 
    panel.background = element_rect(fill = "ghostwhite")) +
      theme(panel.background = element_rect(fill = "white")) +
      theme(legend.text = element_text(size = 9), 
    legend.background = element_rect(size = 0.7))  })
}