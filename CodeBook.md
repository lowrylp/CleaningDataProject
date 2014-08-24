## CodeBook for the Getting and Cleaning Data Course Project 




### RAW Data files provided  
1. The RAW data files were downloaded from the internet here:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Inside this zip file you will find a directory "UCI HAR Dataset".  Extract this diretory and place it in the **R working** folder for this project.
3. No changes are required in this downloaded directory.


### Functional Description for the **run_analysis.R** script


#### Step 1: Merge the training and the test sets to create one data set.
1. Load the required raw source data
```
activities <- read.table("/UCI HAR Dataset/activity_labels.txt")
features   <- read.table("/UCI HAR Dataset/features.txt")
xtrain     <- read.table("/UCI HAR Dataset/train/X_train.txt")
ytrain     <- read.table("/UCI HAR Dataset/train/y_train.txt")
trainsub   <- read.table("/UCI HAR Dataset/train/subject_train.txt")
xtest      <- read.table("/UCI HAR Dataset/test/X_test.txt")
ytest      <- read.table("/UCI HAR Dataset/test/y_test.txt")
testsub    <- read.table("/UCI HAR Dataset/test/subject_test.txt")
```    
2. Put the column names on the data sets
```
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "actindex"
colnames(trainsub) <- "subject"
colnames(xtest)  <- features[,2]
colnames(ytest)  <- "actindex"
colnames(testsub) <- "subject"
```
3. Combine the training data, the test data, then combine both of those
```
cmbtrain <- cbind(trainsub, ytrain, xtrain)
cmbtest  <- cbind(testsub, ytest, xtest)
data <- rbind(cmbtrain, cmbtest)
```

#### Step 2: Extract only the measurements on the mean and standard deviation variables. 
- Also keep the subject and activity variables.    
```
colswanted <- grep("subject|actindex|mean()|std()", colnames(data))
datareduced <- data[,colswanted]
```

#### Step 3: Add descriptive activity names for the activity levels
- Use the 
```
colnames(activities) <- c("index","activity")
datareducedwithactivities <- merge(activities, datareduced, by.x="index", by.y="actindex")
tidydata <- datareducedwithactivities
tidydata$index <- NULL
```

#### Step 4: Appropriately label the data set with descriptive variable names
- Make all of the names lower case for simplicity
- Make sure to remove the pesky () characters
```
tidyheaders <- colnames(tidydata)
tidyheaders <- gsub('-mean()',  'meanvalue',         tidyheaders)
tidyheaders <- gsub('()-X',     'xaxis',             tidyheaders)
tidyheaders <- gsub('-Y',       'yaxis',             tidyheaders)
tidyheaders <- gsub('-Z',       'zaxis',             tidyheaders)
tidyheaders <- gsub('-mean()',  'meanvalue',         tidyheaders)
tidyheaders <- gsub('-std()',   'standarddeviation', tidyheaders)
tidyheaders <- gsub('Freq()',   'frequency',         tidyheaders)
tidyheaders <- gsub('Acc',      'acceleration',      tidyheaders)
tidyheaders <- gsub('tBody',    'timedomainbody',    tidyheaders)
tidyheaders <- gsub('tGravity', 'timedomaingravity', tidyheaders)
tidyheaders <- gsub('fBody',    'frequencydomain',   tidyheaders)
tidyheaders <- gsub('()',       '', tidyheaders, fixed=TRUE)
tidyheaders <- tolower(tidyheaders)
colnames(tidydata) <- tidyheaders
```

#### Step 5: Create a second indeendent tidy data set with the average for each variable
- The averages will be for each activity and each subject
- Write the tidydata set as a csv file
```
tidyavg <- aggregate(tidydata[,3:ncol(tidydata)], by=list(tidydata$activity, tidydata$subject), FUN=mean, na.rm=TRUE)
colnames(tidyavg)[1] = "activity"
colnames(tidyavg)[2] = "subject"
write.csv(tidyavg, file="tidydata.csv", row.names=FALSE)
```


### Tidy Dataset Variable Descriptions ###

Column | Variable Name | Data Type | max | min
------ | ---------------------------------- | --------- | ---------- | ----------
1      | activity                          | text      | WALKING    | LAYING
2      | subject | int | 30 | 1
2      | subject | int | 30 | 1



 




