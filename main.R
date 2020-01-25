library(h2o)

h2o.init()

train_csv <- read.csv("dataset/train.csv")
test_csv <- read.csv("dataset/test.csv")

row_count <- nrow(train_csv)
shuffled_rows <- sample(row_count)
train <- train_csv[head(shuffled_rows,floor(row_count*0.75)),]
valid <- train_csv[tail(shuffled_rows,floor(row_count*0.25)),]


train <- as.h2o(train)
valid <- as.h2o(valid)
test <- as.h2o(test_csv)

# Identify predictors and response
y <- "SalePrice"
x <- setdiff(names(train), y)

# For binary classification, response should be a factor
train[,y] <- as.factor(train[,y])
valid[,y] <- as.factor(valid[,y])

aml <- h2o.automl(x = x,
                     y = y,
                     training_frame = train,
                     nfolds = 5,
                     stopping_tolerance = 0.005,
                     sort_metric = "logloss",
                     stopping_metric = "logloss",
                     stopping_rounds = 3,
                     exclude_algos = c("GLM","DeepLearning","XGBoost","DRF","StackedEnsemble"),
                     max_runtime_secs = 30,
                     seed = 1234)

# View the AutoML Leaderboard
lb <- aml@leaderboard
lb

aml@leader


pred <- h2o.predict(aml@leader, valid)