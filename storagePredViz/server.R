# Define server logic
# dev by 
# R.QIAO <robert.qiao@flinders.edu.au>

shinyServer(function(input, output, session) {
  
  # Return the requested dataset
  # datasetInput <- 
  dataset <- sampleData
  
  # Generate a summary of the dataset
  # output$Summary <- renderPrint({
  #   dataset <- datasetInput()
  #   summary(dataset)
  # })
  
  # -------------------------
  # Output: Historical Plots
  # -------------------------
  
  output$historyscatter <- renderPlot({
    plot(x=dataset$Date, y=dataset$totalUsageGB)
  })
  
  output$historyheat <- renderPlotly({
    plot_ly(dataset, x = ~Date, y = ~totalUsageGB) %>% add_markers()
  })

})