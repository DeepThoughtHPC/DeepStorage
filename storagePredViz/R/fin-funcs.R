# function arimaForecast
#' Establish a prediction based on ARIMA algorithm
#'
#' @param storageUsage  Predicted future value as a time series data. In the storage facility context, the unit is storage capacity in GB
#' @param unitCost      The unit cost of per unit of the predicted future value, in the storage facility context, this is $ per GB
#' @param predperiod    The prediction period ahead that is required, the base unit is in a quarter of a year
#' 
#' @return The predicted financial value with given predicted usage as a time series 
#' 
#' @export
#' @examples

futurePredCost <- function (storageUsage, unitCost, baseCost, seqPeriod = "Y"){
  cost_base = storageUsage$mean * unitCost
  
  ### ========================
  #   Local vars
  ### ========================
  
  # input storageUsage ts
  local_ts_quarter <- as.yearqtr(time(storageUsage$mean))
  local_ts_monthly <- as.yearmon(time(storageUsage$mean))
  local_ts_year <- as.numeric(format(as.Date(time(pred$mean)), "%Y"))
  
  # convert to an xts object
  xtsBase <- as.xts(storageUsage$mean)
  xtsBaseQ <- split(xtsBase, f = "quarters") 
  
  # endpoints
  ep_y = switch (
    seqPeriod, 
    "Y" = endpoints(xtsBase, on="years"),
    "Q" = endpoints(xtsBase, on="quarters")
  )
    
  # planning cost cal
  precure_base = period.apply(xtsBase[,], INDEX = ep_y, FUN = max)
  
  # construct step funcs
  precure_cost = precure_base * unitCost + baseCost

} 

stepConv <- function (xtsData){
  ## local var type - int
  xtsSize <- length(xtsData)
  
  if (xtsSize >= 2) {
    stepfun(x=index(xtsData)[2:xtsSize], y=as.numeric(xtsData[,]), right = TRUE)
  } else { 
    ## error catch improv +
    print ("error")
  }
}

## Plot functions
plot_precure_year_data <- futurePredCost(pred, 0.025, 3500, "Y")
plot_precure_year_step <- stepConv(plot_precure_year_data)

plot_precure_qt_data <- futurePredCost(pred, 0.025, 1000, "Q")
plot_precure_qt_step <- stepConv(plot_precure_qt_data)

# two xts objects converts to long data.frame for ggplot
precureData <- data.frame(merge.xts(plot_precure_qt_data, plot_precure_year_data), names = index(plot_precure_qt_data))
precureData <- precureData %>%
                  fill(plot_precure_year_data, .direction="up")
precureData$ctime <- precureData$names
                          
precureData.long <- melt(data.frame(merge.xts(plot_precure_qt_data, plot_precure_year_data), names = index(plot_precure_qt_data)), 
                         measure = c("plot_precure_qt_data", "plot_precure_year_data"))
precureData.long <- precureData.long %>%
                      filter(if_all(everything(), ~!is.na(.x)))
precureData.long$ctime <- cumsum(precureData.long$names)

precureComp_plot <- ggplot(precureData) +
  geom_rect(aes(xmin = ctime, xmax = lead(ctime),
                                  ymin = plot_precure_qt_data, ymax = plot_precure_year_data),
            fill = "blue", alpha = 0.4) +
  geom_step(aes(x=ctime, y=plot_precure_qt_data)) +
  geom_step(aes(x=ctime, y=plot_precure_year_data)) +
  ggtitle("Expenditure Schema Comparison - Annually vs. Quarterly rolling") + 
  xlab("Rolling Forcase Time Points") + 
  ylab("Normalized Expenditure with NPV evaluation in AU$")
  
# NPV calculation
NPV(coredata(plot_precure_year_data[1]), as.vector(coredata(plot_precure_year_data[2:3])), times=c(1,2), i=0.025)

NPVlist <-list()
for (int in seq(0.01, 0.1, 0.01)){
  NPVlist <- append(NPVlist, NPV(coredata(plot_precure_year_data[1]), as.vector(coredata(plot_precure_year_data[2:3]-1200)), times=c(1,2), i=int))
}

NPVlist_Q <- list()
for (int in seq(0.01/4, 0.1/4, 0.01/4)){
  NPVlist_Q <- append(NPVlist_Q, NPV(coredata(plot_precure_qt_data[1]), 
                                   as.vector(coredata(plot_precure_qt_data[2:length(plot_precure_qt_data)])), 
                                   times=seq(0.25, 2, length.out = (length(plot_precure_qt_data)-1)), 
                                   i=int)/6)
}

# NPV plot
plot(x = seq(0.01, 0.1, 0.01), y=NPVlist)
plot(x = seq(0.01, 0.1, 0.01), y=NPVlist_Q)

mtNPV <- data.frame(interests = seq(0.01, 0.1, 0.01), NPVvalue_Year = unlist(NPVlist), NPVvalue_Q = unlist(NPVlist_Q))
mtNPV.long <- melt(mtNPV, id = "interests", measure = c("NPVvalue_Year", "NPVvalue_Q"))

NPVcompare_1 <- ggplot(mtNPV.long, aes(interests, value, colour = variable)) + 
  geom_line()
