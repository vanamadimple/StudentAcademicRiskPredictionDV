
# STUDENT ACADEMIC RISK PREDICTION

# Install package if it is not already installed
if (!require(randomForest)) {
  install.packages("randomForest")
  library(randomForest)
}

# Select student-mat.csv
data <- read.csv(file.choose(), sep = ";")

# Check dataset
print(head(data))
print(dim(data))

# Create risk category
data$Risk <- ifelse(data$G3 < 10, "At risk", "Not at risk")
data$Risk <- factor(data$Risk)

# Remove grades to avoid using exam grades as predictors
data$G1 <- NULL
data$G2 <- NULL
data$G3 <- NULL

# Split dataset into training and testing data
set.seed(123)
index <- sample(1:nrow(data), 0.7 * nrow(data))

train <- data[index, ]
test <- data[-index, ]

# Train Decision Tree-style Random Forest model
model <- randomForest(Risk ~ ., data = train, ntree = 100)

# Predict test data
pred <- predict(model, test)

# Show confusion matrix
print(table(Actual = test$Risk, Predicted = pred))

# Calculate accuracy
accuracy <- mean(pred == test$Risk) * 100
cat("Accuracy:", round(accuracy, 2), "%\n")

# Show feature importance
print(importance(model))
varImpPlot(model)

# Predict risk for the first five test students
print(data.frame(
  Actual = test$Risk[1:5],
  Predicted = pred[1:5]
))
