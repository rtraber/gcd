# Coursera course: Getting and Cleaning Data  
# Project
# Rolf Traber 2015-2-22

# Run commands step by step or do "Source" in RStudio

# Necessary prerequisites
require(dplyr)
require(plyr)

# Download and unzip into current directory
lnk<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file="Dataset.zip"
download.file(lnk,destfile=file,method="curl")
unzip(file)

# Read common data into tables (4.)
feature<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors=F,col.names=c("feature_id","feature_name"))
activity<-read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F,col.names=c("activity_id","activity_name"))

# Read test datasets into tables (4.)
x_test<-read.table("UCI HAR Dataset/test/X_test.txt",stringsAsFactors=F,col.names=feature$feature_name,check.names=F)
y_test<-read.table("UCI HAR Dataset/test/y_test.txt",stringsAsFactors=F,col.names="activity_id")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",stringsAsFactors=F,col.names=c("subject_id"))

# Read train datasets into tables (4.)
x_train<-read.table("UCI HAR Dataset/train/X_train.txt",stringsAsFactors=F,col.names=feature$feature_name,check.names=F)
y_train<-read.table("UCI HAR Dataset/train/y_train.txt",stringsAsFactors=F,col.names="activity_id")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",stringsAsFactors=F,col.names=c("subject_id"))

# Select only "...mean(" and "...std(" variables (2.)
feature.logical<-grepl('std\\(|mean\\(',feature$feature_name)
feature.filter<-feature[feature.logical,2]
xm_test<-x_test[,feature.logical]
xm_train<-x_train[,feature.logical]

# Add subject and activity variables
xm_test$subject_id<-subject_test$subject_id
xm_test$activity_id=y_test$activity_id

xm_train$subject_id<-subject_train$subject_id
xm_train$activity_id=y_train$activity_id

# merge test and train together (1.)
xm_both<-rbind(xm_test,xm_train)

# replace activity_id by its name (3.)
xm_both<-select(join(xm_both,activity),-activity_id)

# average of each variable for each activity and each subject (5.)
xa=xm_both$activity_name
xs=xm_both$subject_id
xm_both_sum=aggregate(select(xm_both,-c(subject_id,activity_name)),by=list(subject_id=xs,activity_name=xa),mean)
rm(xa,xs)

# write table
write.table(xm_both_sum,file="xm_both_sum_table.txt",row.names=FALSE)

