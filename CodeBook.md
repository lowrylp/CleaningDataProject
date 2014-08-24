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
- Use the Factors in the activities dataset to label the activities 
- Get rid of the index varaiable since it is not needed now
```
colnames(activities) <- c("index","activity")
datareducedwithactivities <- merge(activities, datareduced, by.x="index", by.y="actindex")
tidydata <- datareducedwithactivities
tidydata$index <- NULL
```

#### Step 4: Appropriately label the data set with descriptive variable names
- CamelCase to make the variables easier to read
- Make sure to remove the pesky () characters
```
tidyheaders <- colnames(tidydata)
tidyheaders <- gsub('-mean()',  'MeanValue',         tidyheaders)
tidyheaders <- gsub('()-X',     'Xaxis',             tidyheaders)
tidyheaders <- gsub('-Y',       'Yaxis',             tidyheaders)
tidyheaders <- gsub('-Z',       'Zaxis',             tidyheaders)
tidyheaders <- gsub('-std()',   'StandardDeviation', tidyheaders)
tidyheaders <- gsub('Freq()',   'Frequency',         tidyheaders)
tidyheaders <- gsub('Acc',      'Acceleration',      tidyheaders)
tidyheaders <- gsub('tBody',    'TimeDomainBody',    tidyheaders)
tidyheaders <- gsub('tGravity', 'TimeDomainGravity', tidyheaders)
tidyheaders <- gsub('fBody',    'FrequencyDomain',   tidyheaders)
tidyheaders <- gsub('()',       '', tidyheaders, fixed=TRUE)
colnames(tidydata) <- tidyheaders
```

#### Step 5: Create a second independent tidy data set with the average for each variable
- The averages will be for each activity and each subject
- Write the tidydata set as a csv file
```
tidyavg <- aggregate(tidydata[,3:ncol(tidydata)], by=list(tidydata$activity, tidydata$subject), FUN=mean, na.rm=TRUE)
colnames(tidyavg)[1] = "activity"
colnames(tidyavg)[2] = "subject"
write.csv(tidyavg, file="tidydata.csv", row.names=FALSE)
```


### Tidy Dataset Variable Descriptions ###
- The Maximum and minimum values are or the averaged values in the tidy data set

Column | Variable Name | Data Type | Minimun | Maximun
------ | ---------------------------------- | --------- | ---------- | ----------
1|activity|text|WALKING|LAYING
2|subject|int|1|30
3|TimeDomainBodyAccelerationMeanValueXaxis|float|0.23327544|0.30146102
4|TimeDomainBodyAccelerationMeanValueYaxis|float|-0.032526976|-0.001308288
5|TimeDomainBodyAccelerationMeanValueZaxis|float|-0.1525139|-0.075378469
6|TimeDomainBodyAccelerationStandardDeviationXaxis|float|-0.996068635|0.626917071
7|TimeDomainBodyAccelerationStandardDeviationYaxis|float|-0.990240947|0.616937015
8|TimeDomainBodyAccelerationStandardDeviationZaxis|float|-0.987658662|0.609017879
9|TimeDomainGravityAccelerationMeanValueXaxis|float|-0.680043155|0.974508732
10|TimeDomainGravityAccelerationMeanValueYaxis|float|-0.479894843|0.956593814
11|TimeDomainGravityAccelerationMeanValueZaxis|float|-0.49508872|0.957873042
12|TimeDomainGravityAccelerationStandardDeviationXaxis|float|-0.996764227|-0.829554948
13|TimeDomainGravityAccelerationStandardDeviationYaxis|float|-0.994247649|-0.643578361
14|TimeDomainGravityAccelerationStandardDeviationZaxis|float|-0.99095725|-0.610161166
15|TimeDomainBodyAccelerationJerkMeanValueXaxis|float|0.042688099|0.130193044
16|TimeDomainBodyAccelerationJerkMeanValueYaxis|float|-0.038687211|0.056818586
17|TimeDomainBodyAccelerationJerkMeanValueZaxis|float|-0.067458392|0.038053359
18|TimeDomainBodyAccelerationJerkStandardDeviationXaxis|float|-0.994604542|0.544273037
19|TimeDomainBodyAccelerationJerkStandardDeviationYaxis|float|-0.989513566|0.355306717
20|TimeDomainBodyAccelerationJerkStandardDeviationZaxis|float|-0.993288313|0.031015708
21|TimeDomainBodyGyroMeanValueXaxis|float|-0.205775427|0.192704476
22|TimeDomainBodyGyroMeanValueYaxis|float|-0.204205356|0.027470756
23|TimeDomainBodyGyroMeanValueZaxis|float|-0.072454603|0.179102058
24|TimeDomainBodyGyroStandardDeviationXaxis|float|-0.994276591|0.267657219
25|TimeDomainBodyGyroStandardDeviationYaxis|float|-0.994210472|0.476518714
26|TimeDomainBodyGyroStandardDeviationZaxis|float|-0.985538363|0.564875818
27|TimeDomainBodyGyroJerkMeanValueXaxis|float|-0.157212539|-0.022091627
28|TimeDomainBodyGyroJerkMeanValueYaxis|float|-0.076808992|-0.013202277
29|TimeDomainBodyGyroJerkMeanValueZaxis|float|-0.092499853|-0.006940664
30|TimeDomainBodyGyroJerkStandardDeviationXaxis|float|-0.996542541|0.17914865
31|TimeDomainBodyGyroJerkStandardDeviationYaxis|float|-0.997081576|0.295945926
32|TimeDomainBodyGyroJerkStandardDeviationZaxis|float|-0.995380795|0.193206499
33|TimeDomainBodyAccelerationMagMeanValue|float|-0.986493197|0.644604325
34|TimeDomainBodyAccelerationMagStandardDeviation|float|-0.986464543|0.428405923
35|TimeDomainGravityAccelerationMagMeanValue|float|-0.986493197|0.644604325
36|TimeDomainGravityAccelerationMagStandardDeviation|float|-0.986464543|0.428405923
37|TimeDomainBodyAccelerationJerkMagMeanValue|float|-0.992814715|0.434490401
38|TimeDomainBodyAccelerationJerkMagStandardDeviation|float|-0.994646917|0.450612066
39|TimeDomainBodyGyroMagMeanValue|float|-0.980740847|0.418004609
40|TimeDomainBodyGyroMagStandardDeviation|float|-0.981372676|0.29997598
41|TimeDomainBodyGyroJerkMagMeanValue|float|-0.997322527|0.087581662
42|TimeDomainBodyGyroJerkMagStandardDeviation|float|-0.997666072|0.250173204
43|FrequencyDomainAccelerationMeanValueXaxis|float|-0.995249933|0.537012022
44|FrequencyDomainAccelerationMeanValueYaxis|float|-0.989034304|0.524187687
45|FrequencyDomainAccelerationMeanValueZaxis|float|-0.989473927|0.280735952
46|FrequencyDomainAccelerationStandardDeviationXaxis|float|-0.99660457|0.658506543
47|FrequencyDomainAccelerationStandardDeviationYaxis|float|-0.990680395|0.560191344
48|FrequencyDomainAccelerationStandardDeviationZaxis|float|-0.987224804|0.687124164
49|FrequencyDomainAccelerationMeanValueFrequencyXaxis|float|-0.635913046|0.159123629
50|FrequencyDomainAccelerationMeanValueFrequencyYaxis|float|-0.379518455|0.466528232
51|FrequencyDomainAccelerationMeanValueFrequencyZaxis|float|-0.520114794|0.402532553
52|FrequencyDomainAccelerationJerkMeanValueXaxis|float|-0.994630797|0.474317256
53|FrequencyDomainAccelerationJerkMeanValueYaxis|float|-0.989398824|0.276716853
54|FrequencyDomainAccelerationJerkMeanValueZaxis|float|-0.992018448|0.157775692
55|FrequencyDomainAccelerationJerkStandardDeviationXaxis|float|-0.995073759|0.476803887
56|FrequencyDomainAccelerationJerkStandardDeviationYaxis|float|-0.990468083|0.349771285
57|FrequencyDomainAccelerationJerkStandardDeviationZaxis|float|-0.99310776|-0.006236475
58|FrequencyDomainAccelerationJerkMeanValueFrequencyXaxis|float|-0.576044002|0.331449281
59|FrequencyDomainAccelerationJerkMeanValueFrequencyYaxis|float|-0.601971415|0.195677336
60|FrequencyDomainAccelerationJerkMeanValueFrequencyZaxis|float|-0.627555474|0.230107946
61|FrequencyDomainGyroMeanValueXaxis|float|-0.993122609|0.474962448
62|FrequencyDomainGyroMeanValueYaxis|float|-0.994025488|0.32881701
63|FrequencyDomainGyroMeanValueZaxis|float|-0.985957788|0.49241438
64|FrequencyDomainGyroStandardDeviationXaxis|float|-0.994652185|0.196613287
65|FrequencyDomainGyroStandardDeviationYaxis|float|-0.994353087|0.646233637
66|FrequencyDomainGyroStandardDeviationZaxis|float|-0.986725275|0.522454216
67|FrequencyDomainGyroMeanValueFrequencyXaxis|float|-0.395770151|0.249209412
68|FrequencyDomainGyroMeanValueFrequencyYaxis|float|-0.666814815|0.273141323
69|FrequencyDomainGyroMeanValueFrequencyZaxis|float|-0.507490867|0.377074097
70|FrequencyDomainAccelerationMagMeanValue|float|-0.986800645|0.586637551
71|FrequencyDomainAccelerationMagStandardDeviation|float|-0.987648484|0.178684581
72|FrequencyDomainAccelerationMagMeanValueFrequency|float|-0.31233803|0.435846932
73|FrequencyDomainBodyAccelerationJerkMagMeanValue|float|-0.993998276|0.538404846
74|FrequencyDomainBodyAccelerationJerkMagStandardDeviation|float|-0.994366668|0.316346415
75|FrequencyDomainBodyAccelerationJerkMagMeanValueFrequency|float|-0.125210389|0.4880885
76|FrequencyDomainBodyGyroMagMeanValue|float|-0.986535242|0.203979765
77|FrequencyDomainBodyGyroMagStandardDeviation|float|-0.981468842|0.236659662
78|FrequencyDomainBodyGyroMagMeanValueFrequency|float|-0.456638671|0.409521612
79|FrequencyDomainBodyGyroJerkMagMeanValue|float|-0.997617389|0.146618569
80|FrequencyDomainBodyGyroJerkMagStandardDeviation|float|-0.997585231|0.287834616
81|FrequencyDomainBodyGyroJerkMagMeanValueFrequency|float|-0.182923597|0.42630168




 




