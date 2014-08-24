#  run_analysis.R
#  This script is used to take the original raw data provided
#  and process it into a Tidy Dataset with just the required
#  data fields.   The original data set is in the directory
#  UCI HAR Dataset, in the same directory as this R script.

# Set the working directory for my computer.  This is the location 
# of the script and the raw data directory.
#   setwd("R:\\")
      
# Step 1
#   Merges the training and the test sets to create one data set.
      
#  First, load in the required raw source data
activities <- read.table("/UCI HAR Dataset/activity_labels.txt")
features   <- read.table("/UCI HAR Dataset/features.txt")
xtrain     <- read.table("/UCI HAR Dataset/train/X_train.txt")
ytrain     <- read.table("/UCI HAR Dataset/train/y_train.txt")
trainsub   <- read.table("/UCI HAR Dataset/train/subject_train.txt")
xtest      <- read.table("/UCI HAR Dataset/test/X_test.txt")
ytest      <- read.table("/UCI HAR Dataset/test/y_test.txt")
testsub    <- read.table("/UCI HAR Dataset/test/subject_test.txt")
      
# Put the column names on the dataset
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "actindex"
colnames(trainsub) <- "subject"
colnames(xtest)  <- features[,2]
colnames(ytest)  <- "actindex"
colnames(testsub) <- "subject"
      
# Combine the training and test datasets
cmbtrain <- cbind(trainsub, ytrain, xtrain)
cmbtest  <- cbind(testsub, ytest, xtest)
data <- rbind(cmbtrain, cmbtest)
      
# Step 2
#   Extract only the measurements on the mean and standard
#   deviation for each measurement
      
# Use the combined dataset and reduce it to just the columns 
# with headers that imply mean or std values. Also keep the 
# main subject and activity index fields.
colswanted <- grep("subject|actindex|mean()|std()", colnames(data))
datareduced <- data[,colswanted]
  
# Step 3
#   Uses descriptive activity names to name the activities in the
#   data set
      
# Add appropriate activity Labels
colnames(activities) <- c("index","activity")
datareducedwithactivities <- merge(activities, datareduced, by.x="index", by.y="actindex")
tidydata <- datareducedwithactivities
tidydata$index <- NULL
  
# Step 4
#   Appropriately label the data set with descriptive variable names
      
# Appropriately relabel the variables 
tidyheaders <- colnames(tidydata)
tidyheaders <- gsub('-mean()', 'MeanValue', tidyheaders)
tidyheaders <- gsub('()-X', 'Xaxis', tidyheaders)
tidyheaders <- gsub('-Y', 'Yaxis', tidyheaders)
tidyheaders <- gsub('-Z', 'Zaxis', tidyheaders)
tidyheaders <- gsub('-std()', 'StandardDeviation', tidyheaders)
tidyheaders <- gsub('Freq()', 'Frequency', tidyheaders)
tidyheaders <- gsub('Acc', 'Acceleration', tidyheaders)
tidyheaders <- gsub('tBody', 'TimeDomainBody', tidyheaders)
tidyheaders <- gsub('tGravity', 'TimeDomainGravity', tidyheaders)
tidyheaders <- gsub('fBody', 'FrequencyDomain', tidyheaders)
tidyheaders <- gsub('()', '', tidyheaders, fixed=TRUE)
colnames(tidydata) <- tidyheaders
  
# Step 5
#   Create a second, independent tidy data set with the average
#   for each variable for each activity and each subject
      
tidyavg <- aggregate(tidydata[,3:ncol(tidydata)], by=list(tidydata$activity, tidydata$subject), FUN=mean, na.rm=TRUE)
colnames(tidyavg)[1] = "activity"
colnames(tidyavg)[2] = "subject"
write.csv(tidyavg, file="tidydata.csv", row.names=FALSE)
      