## Getting and Cleaning Data Course Project ##

This README.md describes the purpose and function of the various required 
files to complete the class project for the **Getting and Cleaning Data**
course offered through Coursera.org from Johns Hopkins University, August 2014.

### Description of Project ###
The purpose of this project is to demonstrate our ability to collect, workkwith, and clean a data set. The goal is to prepare a tidy data that can be used for later analysis.  We are required to submit:

* A tidy data set as described below
* A link to a Gitub repository (this one) with your script for performing the anaylsys
* A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called **CodeBook.md**. You should also include a **README.md** in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

### Files in this repository ###
* README.md - This file.
* CodeBook.md - A codebook describing the various data values.
* run_analysis.R - My R script to process the source data and produce the
Tidy Dataset.

### Source (RAW) Data Provided ###
Before you can run the script you must down load the data.  It can be found here:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).</br>
Inside this zip file you will find a directory "UCI HAR Dataset".  Extract this diretory and place it in the **R working** folder for this project.

A full description for this data is available here:</br>
[(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Usin+Smartphones)](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Usin+Smartphones) 

### Script Instructions ###
* Place the run_alanysis.R script in a directory to be used as the working directory
* The directory **UCI HAR Dataset** downloaded and extracted above is also placed in this working directory
* Open RStudio and set the working directory to the directory where you have the script and data setup
* In the RStudio console type:  **source("run_analysis.R",echo=TRUE)**
   

### Script Functionality ###
The script does the five (5) steps required of the project:

1. Merges the training and the test data sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names
5. Creates a second, independent tidy data set with the average of each variable for 
each activity and each subject.

The script writes the tidy data set out twice.  Once using write.table to submit for grading and then again as a csv file to aid in creating the CodeBook.md file
 






