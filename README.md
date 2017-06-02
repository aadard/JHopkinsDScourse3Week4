# JHopkinsDScourse3Week4

READ.ME explaining the analysis in 'run_analysis.R'  
The CourseraJohn Hopkins Data Science course 03  
Author: Abdelaziz A  
Date:   02-06-2017  
Note: A description of the variables in 'run_analysis.R' can be found in 'CodeBook.txt' 

## RAW DATA
The script in 'run_analysis.R' downloads and unzips accelerometer data
from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip". 

The data set contains a training and test set in the files 'X_traint.txt' and'X_test.txt', respectively. These two files are read in separately as data frames.

The names of the variables in these two data sets can be found in 'features.txt'. These names are simplified and assigned to the colums of the two data sets.

Furthermore, the data on the subjects of the experiments are read in from 'subject_test.txt' and 'subject_train.txt' for the test and training set, respectively.

The labels of the activities for each measurement can be found in 'y_test.txt' and 'y_train.txt' for the test and training set, respectively.

The file 'activity_labels.txt' contains a  look-up table for the activities performed by the subjects. 

## STEPS IN THE ANALYSIS
The zip-file is downloaded and unzipped. The folder name is then renamed from "UCI HAR Dataset" to "data".

All the relevant files are then read in using read.table() and stored separately. The measurements are read in in two parts, a testing and training set.

After reading in the data, the two data set are first merged using the function rbind().

The next step is to simplify the names in 'features' and to subsequently assign them to the columns of the complete data set, called 'completeSet'. The simplified and tidy names are then also added to the training and test sets.

The labels for the activities and subjects are then added to the separate testing, training and complete data set. 

Next, the actual activities are added to the complete data set using a look-up table found in the file 'activity_labels.txt'.

Using grep("mean",names(completeSet)) the indices for the columns containing measurements on the mean are found. These are extracted and stored in a new data frame. The same is done for measurements on the standard deviation.

Using the split() function the complete data set is split according to the activity. The mean is then calculated for each variable for each activity.

Again, using the split() function the complete data set is now split according for each subject. The mean is then calculated for each variable for each subject.

Finally, a tidy set is written to a text file 'tidyDataSetMean.txt' containing the mean of the variables for each subject and activity. The corresponding activity or subject can be found in the name of the column.
