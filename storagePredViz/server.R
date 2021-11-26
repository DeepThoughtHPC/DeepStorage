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
  
  ## History Plots
  output$historyscatter <- renderPlot({
    plot(x=dataset$Date, y=dataset$totalUsageGB)
  })

  output$historystream <- renderPlotly({
    plot_ly(dataset, x = ~Date, y = ~totalUsageGB) %>% add_markers()
  })
  
  output$historyrange <- renderPlotly({
    plot_ly(dataset, x = ~Date, y = ~totalUsageGB, type = 'scatter', mode = "lines'") %>% 
      add_trace(x = ~Date, y = ~totalUsageGB) %>%
      layout(showlegend = F, title = 'Time Series of Historical Data', 
             xaxis = list(rangeslider = list(visible = T))) %>%
      add_markers()
  })

  ## PCA on Historic data
  output$historyseason <- renderPlot({
    plot(ddataDump$seasonal)
  })  
  
  output$historytrend <- renderPlot({
    plot(ddataDump$trend)
  })  
  
  output$historyrandom <- renderPlot({
    plot(ddataDump$random)
  })  
  
  # -------------------------
  # Output: Historical Plots
  # -------------------------
  output$pred_plot <- renderPlot({
    plot(pred)
  })
  
  # -------------------------
  # Output: Financial Plots
  # -------------------------
  
  output$fin_exp_year <- renderPlot({
    plot(plot_precure_year_step)
  })
  
  output$fin_exp_quarter <- renderPlot({
    plot(plot_precure_qt_step)
  })
  
  output$fin_exp_compare <- renderPlot({
    precureComp_plot
  })
    
  output$fin_exp_npv_y <- renderPlot({
    plot(x = seq(0.01, 0.1, 0.01), y=NPVlist)
  })
  
  output$fin_exp_npv_q <- renderPlot({
    plot(x = seq(0.01, 0.1, 0.01), y=NPVlist_Q)
  })
  
  output$fin_exp_npv_int <- renderPlot({
    NPVcompare_1
  })
})