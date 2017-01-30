
library(dplyr)


filename<-"data.zip"


## check if the zip was already downloaded
if (!file.exists(filename)){
  ##download file
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename)
}  
##Check if there was already an unziped version
if (!file.exists("UCI HAR Dataset")) { 
  ##unzip file
  unzip(filename) 
}

##load files
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
train<-read.table("UCI HAR Dataset/train/X_train.txt")
trainactivities<-read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubjects<-read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(trainactivities)<-"activity_id"
colnames(trainsubjects)<-"subject_id"
test<-read.table("UCI HAR Dataset/test/X_test.txt")
testactivities<-read.table("UCI HAR Dataset/test/Y_test.txt")
testsubjects<-read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(testactivities)<-"activity_id"
colnames(testsubjects)<-"subject_id"
colnames(activities)<-c("activity_id", "activity")
colnames(features)<-c("feature_id", "feature")
###bind columns together
traint<-bind_cols(trainsubjects, trainactivities, train)
testt <- bind_cols(testsubjects, testactivities, test)
##bind rows together
allData <- bind_rows(traint, testt)

##get only the features we want
allData<-merge(allData, activities, by.x="activity_id", by.y="activity_id")
allData<-merge(allData, features, by.x="subject_id", by.y="feature_id")
wantedRows <- allData %>% filter(grepl(".*mean.*|.*std.*", feature))

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)






