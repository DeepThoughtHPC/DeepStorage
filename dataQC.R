## data integraty checks

plotCategories <- c("AllocatedGB", "UsageGB", "Date", "College")
plotData <- testData[plotCategories]
ggplot(plotData, aes(x=Date, y=AllocatedGB)) + geom_line(aes(colour=College))
ggplot(plotData, aes(x=Date, y=UsageGB)) + geom_line(aes(colour=College))

