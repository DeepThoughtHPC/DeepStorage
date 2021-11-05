## Read training and test data to a data.frame
library(usethis)
library(dplyr)

basePath = "datafiles/"
colClasses = c("AllocatedGB" = "integer", 
               "College" = "character", 
               "UsageGB" = "integer", 
               "X_time" = "character", 
               "source" = "character", 
               "sourcetype" = "character")
cbglData <- read.csv(paste(basePath, "CBGL-new.csv", sep=''), header = TRUE, sep = ',', colClasses = colClasses)
cepswData <- read.csv(paste(basePath, "CEPSW-new.csv", sep=''), header = TRUE, sep = ',', colClasses = colClasses)
chassData <- read.csv(paste(basePath, "CHASS-new.csv", sep=''), header = TRUE, sep = ',', colClasses = colClasses)
cmphData <- read.csv(paste(basePath, "CMPH-new.csv", sep=''), header = TRUE, sep = ',', colClasses = colClasses)
cnhsData <- read.csv(paste(basePath, "CNHS-new.csv", sep=''), header = TRUE, sep = ',', colClasses = colClasses)
cseData <- read.csv(paste(basePath, "CSE-new.csv", sep=''), header = TRUE, sep = ',', colClasses = colClasses)

## date fix
cbglData$Date <- as.Date(cbglData$X_time)
cepswData$Date <- as.Date(cepswData$X_time)
chassData$Date <- as.Date(chassData$X_time)
cmphData$Date <- as.Date(cmphData$X_time)
cnhsData$Date <- as.Date(cnhsData$X_time)
cseData$Date <- as.Date(cseData$X_time)

## data clean and validation
cbglDataClean <- cbglData[cbglData$AllocatedGB != 0, ]
cepswDataClean <- cepswData[cepswData$AllocatedGB != 0, ]
chassDataClean <- chassData[chassData$AllocatedGB != 0, ]
cmphDataClean <- cmphData[cmphData$AllocatedGB != 0, ]
cnhsDataClean <- cnhsData[cnhsData$AllocatedGB != 0, ]
cseDataClean <- cseData[cseData$AllocatedGB !=0, ]
  
## combine dataset to create a summary dataset
testData <- bind_rows(cbglDataClean, cepswDataClean, chassDataClean, cmphDataClean, cnhsDataClean, cseDataClean)
allDates <- unique(testData$Date)
testDataSorted <- group_by(testData, testData$Date)
# data sanity checks
for (date in as.character(allDates)) {
  numEntries <- count(testData[testData$Date == as.Date(date),])
  if ( numEntries < 6) {
     testDataCleaned <- testData[testData$Date != as.Date(date),]
  }
}

testDataSummary <- testDataCleaned %>% 
                    group_by(Date = testDataCleaned$Date, testDataCleaned$College) %>% 
                    slice_head(n=1) %>%
                    summarise(totalAllocatedGB = sum(AllocatedGB), totalUsageGB = sum(UsageGB), n=n() )
testDataSummaryDataframe <- as.data.frame(testDataSummary)

testDataDeployRaw <- testDataSummaryDataframe %>%
                    group_by(Date = testDataSummary$Date) %>%
                    summarise(totalAllocatedGB = sum(totalAllocatedGB), totalUsageGB = sum(totalUsageGB), n=n())
testDataDeployRawDataframe <- as.data.frame(testDataDeployRaw)
testdataDeploy <- testDataDeployRawDataframe[testDataDeployRawDataframe$n >= 6,]
testDataDeployDataframe <- as.data.frame(testdataDeploy)

usethis::use_data(cbglData, overwrite = TRUE)
usethis::use_data(cepswData, overwrite = TRUE)
usethis::use_data(chassData, overwrite = TRUE)
usethis::use_data(cmphData, overwrite = TRUE)
usethis::use_data(cnhsData, overwrite = TRUE)
usethis::use_data(cseData, overwrite = TRUE)

