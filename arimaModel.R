library(ggplot2)
library(reshape2)
library(xts)

library(fUnitRoots)
library(lmtest)

## data extractions
sampleCategories <- c("totalUsageGB", "Date")
sampleData <- testDataDeployDataframe[sampleCategories]

# sampleData$id <- sampleData$Date
# ddataDump <- melt(sampleData, id = "id")
# plot (sampleData$Date, sampleData$totalUsageGB)

sampleDataDump <- xts(sampleData[,1], order.by=as.Date(sampleData[,2], "%y/%m/%d"))
monthlyDataDump <- apply.monthly(sampleDataDump, mean)

tsData <- ts(monthlyDataDump, frequency = 12, start = c(2019, 07))
ddataDump <- decompose(tsData, 'multiplicative')


plot(ddataDump)

# plot(ddata$trend)
# plot(ddata$seasonal)
# plot(ddata$random)

## ARIMA model = stationarity + seasonality
# stationarity
urkpssTest(tsData, type = c("tau"), lags = c("short"),use.lag = NULL, doplot = TRUE)
tsstationary = diff(tsData, differences=1)
# remove stationary
plot(tsstationary)
# autocorrelation -- confirming no linear association between observations sep by larger lags
acf(tsData,lag.max=34)  

timeseriesseasonallyadjusted <- tsData - ddataDump$seasonal
tsstationary <- diff(timeseriesseasonallyadjusted, differences=1)
plot(tsstationary)

# model fitting
acf(tsstationary, lag.max=34)
pacf(tsstationary, lag.max=34)

fitARIMA <- arima(tsData, order=c(1,1,1),seasonal = list(order = c(1,0,0), period = 12),method="ML")
coeftest(fitARIMA)
confint(fitARIMA)

# diagnostics
acf(fitARIMA$residuals)
library(FitAR)
boxresult <- LjungBoxTest (fitARIMA$residuals,k=2,StartLag=1)
plot(boxresult[,3],main= "Ljung-Box Q Test", ylab= "P-values", xlab= "Lag")
qqnorm(fitARIMA$residuals)
qqline(fitARIMA$residuals)

# model tunning
library(forecast)
auto.arima(tsData, trace=TRUE)

# predictions
predict(fitARIMA, n.ahead = 3)

futurVal <- forecast(fitARIMA,h=3, level=c(90))
plot(futurVal)

# rolling forcasting
# One-step forecasts without re-estimation
library(fpp)
train <- tsData[1:12]
fit <- auto.arima(train)
refit <- Arima(tsData, model=fit)
fc <- fitted(refit)[13]

# function arimaForecast
#' Establish a prediction based on ARIMA algorithm
#'
#' @param tsInput A time series dataset
#' @param h A time period
#'
#' @export
#' @examples

arimaForecast <- function(tsInput, h) {
  forecast( Arima(tsInput, order=c(1,1,1), seasonal = list(order = c(1,0,0), period = h), method="ML") )
}

pred <- arimaForecast(tsData, h=12)
plot (pred)


