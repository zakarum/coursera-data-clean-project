#Load required packages
require(dplyr, quietly = TRUE)
require(data.table, quietly = TRUE)
require(reshape2, quietly = TRUE)
require(plyr, quietly = TRUE)

#read raw data
features <- read.table("./UCI HAR Dataset/features.txt")
label <- read.table("./UCI HAR Dataset/activity_labels.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Read column names from features
names(xtest) <- as.character(features[,2])

#label activity code
ytest <- left_join(ytest, label)
names(ytest) <- c("label", "activity")

#Add column name to subject
names(subject_test) <- "subject"

#cobine the test data sets
test_dataset <- bind_cols(list(subject_test, ytest, xtest))

#Do the same as test data
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
names(xtrain) <- as.character(features[,2])
ytrain <- left_join(ytrain, label)
names(ytrain) <- c("label", "activity")
names(subject_train) <- "subject"
train_dataset <- bind_cols(list(subject_train, ytrain, xtrain))
########################

#Merge test and train data
full_dataset <- bind_rows(test_dataset,train_dataset)

#Select only Subject, activity and mean/std value of the features
subset <- select(full_dataset, matches("^subject$|^activity$|mean\\(\\)|std\\(\\)"))

#calcublate mean value for each features
tidydata <- aggregate(. ~ subject + activity, subset, mean)

#write to the txt file
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)