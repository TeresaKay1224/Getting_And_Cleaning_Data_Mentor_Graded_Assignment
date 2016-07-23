library(plyr)

features <- read.table('features.txt', header = FALSE)

#Pull in training data
train_x <- read.table('X_train.txt', header = FALSE)
train_y <- read.table('y_train.txt', header = FALSE)
train_subject <- read.table('subject_train.txt', header = FALSE)

#Combine columns of subject and y for training data
train_subject <- rename(train_subject, c("V1"="subject"))
train_y <- rename(train_y, c("V1"="activity"))
train <- cbind(train_subject, train_y)

#Combine subject/y with x for training data
total_train <- cbind(train, train_x)

#Pull in test data
test_y <- read.table('y_test.txt', header=FALSE)
test_x <- read.table('X_test.txt', header=FALSE)
test_subject <- read.table('subject_test.txt', header = FALSE)

#Combine columns of subject and y for test data
test_subject <- rename(test_subject, c("V1"="subject"))
test_y <- rename(test_y, c("V1"="activity"))
test <- cbind(test_subject, test_y)

#Combine subject/y with x for test data
total_test <- cbind(test, test_x)

#Give features names to columns of x axis data
names(test_x) <- features$V2
names(train_x) <- features$V2

#Combine test and train data
total <- rbind(total_train, total_test)

#Get only columns for mean and std
sd_features = features$V2[grep('std', features$V2)]
mean_features = features$V2[grep('mean', features$V2)]
mean_features <- as.character(mean_features)
sd_features <- as.character(sd_features)
mean_sd_features = c("subject", "activity", sd_features, mean_features)
sd_mean <- subset(total, select = mean_sd_features)

#Replace activity codes with descriptions
activity_labels <- read.table('activity_labels.txt', header = FALSE)
sd_mean$activity <- activity_labels$V2[sd_mean$activity]

#Create data set with the average of each variable for each activity and each subject
library(plyr)
mean_by_subject_activity <- aggregate(. ~ subject + activity, sd_mean, mean)

#Generate Code Book
library(memisc)
cdbk <- codebook(mean_by_subject_activity)
capture.output(show(cdbk), file="codebook.txt")

