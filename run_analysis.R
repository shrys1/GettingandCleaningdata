library(dplyr)
## pre Steps
## Install and load dplyr package
## Download the file using download.file function
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,"./data.zip")
## Create a directory "data" to save files
if(!dir.exists("./data")){
dir.create("./data")
}
## Unzip the files into created data directory
unzip("./data.zip", exdir = "./data")
## Read all the files into R using read.table and give them appropriate column names
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("activity ID","activity")
features <- read.table("./data/UCI HAR Dataset/features.txt")
colnames(features) <- c("n","feature")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- "subjectID"
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- "subjectID"
x_test <- read.table("./data/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
colnames(x_test) <- features$feature
colnames(y_test) <- "activityID"
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
colnames(y_train) <- "activityID"
colnames(x_train) <- features$feature
## Merge the data using cbind and rbind
Total <- rbind(cbind(subject_test,y_test,x_test),cbind(subject_train,y_train,x_train))
## Using select function select columns containing mean and std while keeping first and second column
meanstd <- select(Total, subjectID, activityID, contains("mean"), contains("std"))
## substitute the activityID column with activity names
meanstd$activityID <- activity_labels[meanstd$activityID, 2]
## group the merged data by subjectID and activityID columns and summarise mean
finaldata <- meanstd %>% group_by(subjectID, activityID) %>% summarise_all(funs(mean))
## create a new file in data directory of txt format
write.table(finaldata,"./data/FinalData.txt")