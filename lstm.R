library(keras)
library(tensorflow)
library(reticulate)

# library(dplyr)
library(xts)

## data extractions
sampleCategories <- c("totalUsageGB", "Date")
sampleData <- testDataDeployDataframe[sampleCategories]
sampleDataDump <- xts(sampleData[,1], order.by=as.Date(sampleData[,2], "%y/%m/%d"))

scale_factors <- c(mean(sampleData$totalUsageGB), sd(sampleData$totalUsageGB))
scaled_train <- sampleData %>%
                  select(totalUsageGB) %>%
                  mutate(totalUsageGB = (totalUsageGB - scale_factors[1])/scale_factors[2])

## LSMT prams
prediction <- 12
lag <- prediction

# LSMT
scaled_train <- as.matrix(scaled_train)

# we lag the data 11 times and arrange that into columns
x_train_data <- t(sapply(
  1:(length(scaled_train) - lag - prediction + 1),
  function(x) scaled_train[x:(x + lag - 1), 1]
))

x_train_arr <- array(
  data = as.numeric(unlist(x_train_data)),
  dim = c(
    nrow(x_train_data),
    lag,
    1
  )
)

y_train_data <- t(sapply(
  (1 + lag):(length(scaled_train) - prediction + 1),
  function(x) scaled_train[x:(x + prediction - 1)]
))

y_train_arr <- array(
  data = as.numeric(unlist(y_train_data)),
  dim = c(
    nrow(y_train_data),
    prediction,
    1
  )
)

x_test <- sampleData$totalUsageGB[(nrow(scaled_train) - prediction + 1): nrow(scaled_train)]
# scale the data with same scaling factors as for training
x_test_scaled <- (x_test - scale_factors[1]) / scale_factors[2]

x_pred_arr <- array(
  data = x_test_scaled,
  dim = c(
    1,
    lag,
    1
  )
)

lstm_model <- keras_model_sequential()
lstm_model %>%
  layer_lstm(units = 2, # size of the layer
             batch_input_shape = c(1, 12, 1), # batch size, timesteps, features
             return_sequences = TRUE,
             stateful = TRUE) %>%
  # fraction of the units to drop for the linear transformation of the inputs
  layer_dropout(rate = 0.5) %>%
  layer_lstm(units = 2,
             return_sequences = TRUE,
             stateful = TRUE) %>%
  layer_dropout(rate = 0.5) %>%
  time_distributed(keras::layer_dense(units = 1))

## LSTM
lstm_model %>%
  compile(loss = 'mae', optimizer = 'adam', metrics = 'accuracy')

summary(lstm_model)

## LSTM train
lstm_model %>% fit(
  x = x_train_arr,
  y = y_train_arr,
  batch_size = 1,
  epochs = 20,
  verbose = 0,
  shuffle = FALSE
)

## LSTM prediction
lstm_forecast <- lstm_model %>%
  predict(x_pred_arr, batch_size = 1) %>%
  .[, , 1]

# we need to rescale the data to restore the original values
lstm_forecast <- lstm_forecast * scale_factors[2] + scale_factors[1]
fitted <- predict(lstm_model, x_train_arr, batch_size = 1) %>%
  .[, , 1]

if (dim(fitted)[2] > 1) {
  fit <- c(fitted[, 1], fitted[dim(fitted)[1], 2:dim(fitted)[2]])
} else {
  fit <- fitted[, 1]
}

# additionally we need to rescale the data
fitted <- fit * scale_factors[2] + scale_factors[1]
nrow(fitted)


