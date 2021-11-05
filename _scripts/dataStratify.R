library(stringr)

## eligible entries from raw data
dataCategories <- list("AllocatedGB", "College", "UsageGB", "X_time", "source", "sourcetype")
colClasses = c("AllocatedGB" = "integer", 
               "College" = "character", 
               "UsageGB" = "integer", 
               "X_time" = "character", 
               "source" = "character", 
               "sourcetype" = "character")

files <- as.list(list.files(path = 'datafiles-raw/', pattern = '*.csv'))

for (csv in files){
  inpath <- paste('datafiles-raw/', csv, sep = '')
  dataset <- read.csv(inpath, sep = ',', header = TRUE,colClasses = colClasses)

  # for (category in dataCategories) {
  #  newDataset[category] <- dataset[category]
  #}
  
  newDataset <- dataset[unlist(dataCategories)]
  
  ## output file path
  csv <- gsub(".csv", "-new.csv", csv)
  outpath <- paste('datafiles/', csv, sep = '')
  write.csv(newDataset, file=outpath, row.names = FALSE)
}

