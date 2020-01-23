library(h2o)
localH2O = h2o.init()

train <- read.csv(file="dataset/train.csv", header=TRUE, sep=",")
test <- read.csv(file="dataset/test.csv", header=TRUE, sep=",")