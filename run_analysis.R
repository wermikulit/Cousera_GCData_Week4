# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Dowloaded and extracted into "~/getdata-projectfiles-UCI HAR Dataset" directory
# The script 
# 1. Merges the training and the test sets to create one data set. 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set 
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the
# average of each variable for each activity and each subject.

library(data.table)
library(dplyr)
library(stringr)

setwd("~/R/Coursera_GCData/Week 4") # my work dir for this assignment
dirSet<-"getdata-projectfiles-UCI HAR Dataset"
# read list of Features
dtFeatures<-fread(input = paste(dirSet,"/features.txt", sep = ""))

# Names of the columns like %mean% or %std% (mean and standard deviation for each measurement)
dtFMeanChar<-dtFeatures$V2[str_to_lower(dtFeatures$V2)%like%"mean"|str_to_lower(dtFeatures$V2)%like%"std"]
# Indexes of the columns like %mean% or %std% (mean and standard deviation for each measurement)
dtFMeanNum<-dtFeatures$V1[which(str_to_lower(dtFeatures$V2)%like%"mean"|str_to_lower(dtFeatures$V2)%like%"std")]

# Read Train file, only "mean" and "std" columns
dtTrainMeanStd<-fread(input = paste(dirSet,"/train/X_train.txt", sep = ""), col.names = dtFMeanChar, select = dtFMeanNum)
#read Train subjects
dtTrainSubj<-fread(input = paste(dirSet,"/train/subject_train.txt", sep = ""), col.names = "Subject")
#read Train activities
dtTrainAct<-fread(input = paste(dirSet,"/train/y_train.txt", sep = ""), col.names = "Activity")
# add Subj and Activity columns
dtTrain<-cbind(dtTrainSubj, dtTrainAct, dtTrainMeanStd)

# Read Test file, only "mean" and "std" columns
dtTestMeanStd<-fread(input = paste(dirSet,"/test/X_test.txt", sep = ""), col.names = dtFMeanChar, select = dtFMeanNum)
#read Test subjects
dtTestSubj<-fread(input = paste(dirSet,"/test/subject_test.txt", sep = ""), col.names = "Subject")
#read Test activities
dtTestAct<-fread(input = paste(dirSet,"/test/y_test.txt", sep = ""), col.names = "Activity")
# add Subj and Activity columns
dtTest<-cbind(dtTestSubj, dtTestAct, dtTestMeanStd)

# merge train and test data
dt<-rbind(dtTrain, dtTest)

# create independent tidy data set with the
# average of each variable for each activity and each subject
z<-dt%>%group_by(Subject, Activity)%>%summarise_each("mean")

# upload resulting data set as a txt file created with write.table() using row.name=FALSE
write.table(z, file = "week4_ass_tidy_dataset.txt", row.names = FALSE)
