# Coursera: John Hopkins Data Science
# Course 03: Getting and Cleaning Data
# Week 4 Assignment

# Author: Abdelaziz A
# Date:   01-06-2017

# 1.      This script downloads and unzips accelerometer data
# 2.      The data is read in and cleaned. 
# 3.      The variable names are simplified. 
# 4.      Training and test data sets are merged by a simple 
#         rbind() operation.
# 5.      Measurements for the mean and standard deviation
#         are extracted using the grep() function in combination
#         with the variable names that can contain 'mean' or 'std'.
# 6.      Lastly, averages are calculated for each activity and
#         subject.

# DOWNLOAD AND UNZIP FILES -------------
# set working directory to path of current file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# URL of zip-file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# download the file
download.file(fileUrl,destfile = "./data.zip")

# unzip the files
unzip("./data.zip",exdir=".")

# rename folder to 'data' for convenience
file.rename("UCI HAR Dataset","data")  


# READING IN DATA --------------

# test data
testSet <- read.table("./data/test/X_test.txt")

# training set
trainSet <- read.table("./data/train/X_train.txt")

# activity labels (test)
testLabels <- read.table("./data/test/y_test.txt",
                         header=FALSE,col.names = "activitylabel")

# activity labels (train)
trainLabels <- read.table("./data/train/y_train.txt",
                          header=FALSE,col.names = "activitylabel")

# subject labels (test)
testSubject <- read.table("./data/test/subject_test.txt",
                          header=FALSE,col.names = "subject")

# subject labels (train)
trainSubject <- read.table("./data/train/subject_train.txt",
                           header=FALSE,col.names = "subject")

# features
features <- read.table("./data/features.txt")

# activities
activities <- read.table("./data/activity_labels.txt")


# MERGE DATA SETS ----------
# merge data sets using rbind()
completeSet <- rbind(trainSet,testSet)


# FEATURES -----------------

# character vector
features <- as.character(features$V2)

# Now the feature names will be simplified

# Remove caps first
features <- tolower(features)

# remove special characters to improve readability and 
# coding convenience

# find set of unique characters that are used to describe features
uniqueChar <- unique(unlist(strsplit(
                     paste(features,sep = "",collapse=""),"")))
uniqueChar

# variable uniqueChar shows us that special characters 
# '(', ')', '-' and ',' are used, besides letters and numbers

# remove character: (
features <- gsub("\\(","",features)

# remove character: )
features <- gsub("\\)","",features)

# remove character: -
features <- gsub("-","",features)

# remove character: ,
features <- gsub(",","",features)

# data frame of features (for inspecting names)
features <- as.data.frame(features)




# ADD ACTIVITY AND SUBJECT LABELS TO DATA  -----------

# first use features for variable names of data
names(testSet)      <- features$features
names(trainSet)     <- features$features
names(completeSet)  <- features$features

# add activity and subject labels to to test and training set
testSet$activityLabel  <- as.numeric(testLabels$activitylabel)
testSet$subjectLabel   <- as.numeric(testSubject$subject)
trainSet$activityLabel <- as.numeric(trainLabels$activitylabel)
trainSet$subjectLabel  <- as.numeric(trainSubject$subject)

# add activity and subject label to complete data set
completeSet$activitylabel <- as.numeric(rbind(trainLabels,testLabels)$activitylabel)
completeSet$subject       <- as.numeric(rbind(trainSubject,testSubject)$subject)




# LOOK-UP TABLE FOR ACTIVITY -------------

activities$V2 <- tolower(activities$V2)
activities$V2 <- gsub("_","",activities$V2)

# apply look-up table to add activities to data sets
completeSet$activity <- activities$V2[unlist(completeSet$activitylabel)]



# EXRACT ONLY MEASUREMENTS ON MEAN AND STANDARD DEV --------------

# find columns with measurements on mean
meanVariables <- grep("mean",names(completeSet))

# find columns with measurements on standard deviation
stdVariables <- grep("std",names(completeSet))

# measurements on mean
meanData <- completeSet[,meanVariables]

# measurements on standard deviation
stdData <- completeSet[,stdVariables]

# combine data
meanStdData <- cbind(meanData,stdData)

# AVERAGE FOR EACH ACTIVITY AND SUBJECT -----------

# split data on mean an standard deviation
splitData <- split(meanStdData,list(completeSet$subject,completeSet$activitylabel))

# for each data frame within the list: calculate mean of variables
splitDataMean <- lapply(splitData, function (x) lapply(x, mean, na.rm=TRUE))

# for loop to extract data from list and to create tidy data frame
count = 1;
tidyDataDF <- data.frame(matrix(data=NA,nrow=180,ncol=length(meanStdData)+2))
for(i in 1:30){
          for(j in 1:6){
                    tidyDataDF[count,1] <- i
                    tidyDataDF[count,2] <- j
                    tidyDataDF[count,3:(ncol(meanStdData)+2)] <- unlist(splitDataMean[count])
                    
                    count <- count + 1
          }
}

# change names for tidy data set
names(tidyDataDF)[c(1,2)] <- c("subject","activity")
names(tidyDataDF)[3:ncol(tidyDataDF)] <- names(meanStdData) 


# WRITE OUT TIDY DATA SET IN A SINGLE FILE ---------------

write.table(tidyDataDF,"./tidyDataSetMean.txt",row.names = FALSE)



