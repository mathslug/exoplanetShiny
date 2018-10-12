function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$bar1 = renderPlot({
    bar1data = scatter_data %>% filter(., discovery_year == input$slider1)
    ggplot(bar1data, aes(x = detection_type)) + geom_bar()
  })
}