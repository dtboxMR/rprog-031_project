## Script for data analysis

## Getting the current working directory and saving it 
## into a variable. At the end of the script we'll resore it.
old_wd<-getwd()

## Setting the new working directory to the directory where our data is stored
                        ## WARNING: ##
## If the data on your computer is stored in a different directory 
## you'll have to change the path in the following line
setwd("~/UCI HAR Dataset")

                ## 1. Loading Data ##
        ## 1.1 Loading tables for training dataset
## The following dataframe contains training observations for 561 variables
train<-read.table("train/X_train.txt", header = FALSE)

## The following dataframe contains subject IDs for each training observation. 
## Subjects are people who performed the activities for this dataset.  
## In total there were 30 people involved, so their IDs range from 1 to 30. 
## The dataframe has one column with subject IDs, the row number corresponds to
## the number of observation, the subject ID corresponds to the person 
## involved in this observation.
train_subjects<-read.table("train/subject_train.txt", header = FALSE)

## The following dataframe is similar to the previous one 
## only instead of subjects it lists activities for each observation.
train_activities<-read.table("train/y_train.txt", header = FALSE)

        # 1.2 Loading data for test dataset
# The following dataframe contains test observations for 561 variables
test<-read.table("test/X_test.txt", header = FALSE)

## The following dataframe contains subject IDs for each test observation. 
test_subjects<-read.table("test/subject_test.txt", header = FALSE)

## Activities for each test observation
test_activities<-read.table("test/y_test.txt", header = FALSE)

        ## 1.3 Loading names
## Loading variable names. The resulting dataframe has 2 columns: 
## variable number and variable name.
feature_names<-read.table("features.txt", header = FALSE)

## Loading activity names. This dataframe also has 2 columns:
## activity number and activity name
activity_names<-read.table("activity_labels.txt", header = FALSE)

                ## 2. Merging ##
## Merging the train and test dataset, the resulting dataframe has 
## 561 columns (variables) and 10299 rows (observations)
new_df<-rbind(train, test)

                ## 3. Extracting Variables ##
## Now we are going to extract only variables with mean values 
## and standard deviation values. 

## Loading dplyr package
library(dplyr)

## From variable names extracting names corresponding to mean values
mean_names<-filter(feature_names, grepl("mean", V2))

## From variable names extracting names corresponding to 
## standard deviation values
std_names<-filter(feature_names, grepl("std", V2))

## Combining all extracted names together
var_names<-rbind(mean_names, std_names)

## Ordering variable names by their IDs (= by the first column)
var_names<-arrange(var_names, V1)

## Creating a vector with variable IDs corresponding to the variables 
## we are going to extract
var_names_vect<-var_names[, "V1"]

## Extracting the data from our dataframe corresponding to selected variables
new_df<-new_df[, var_names_vect]

## In the resulting dataframe (which now has 79 variables) changing the column
## names to corresponding variable names
names(new_df) = var_names$V2

                ## 4. Adding Columns ##
## 4.1 Adding the column of activities to the dataframe
## Combining activities from the training dataset and the test dataset
activities<-rbind(train_activities, test_activities)

## Changing the column name
names(activities)="activity_type"

## Changing numbers (activities IDs) to names in the activities dataframe
activity_type<-factor(activities$activity_type, labels = activity_names$V2)

## Now we can add the activity column to our dataframe.
new_df<-cbind(activity_type, new_df)

## 4.2 Adding the subjects column in a similar way
## Combining subjects from the training and the test sets
subjects<-rbind(train_subjects, test_subjects)

## Changing the column name
names(subjects)="subject_id"

## Adding the subjects column to the dataframe
new_df<-cbind(subjects, new_df)

                ## 5. Creating ## 
## Creating a new dataset with the average of each variable for each subject and each activity
summary<-summarise_each(group_by(new_df, subject_id, activity_type), funs(mean))

                ## 6. Writing the Result into a File ##
## Writing the resulting dataset to file
write.table(summary, "summary.txt", row.names = FALSE)

##Setting the working directory back
setwd(old_wd)
