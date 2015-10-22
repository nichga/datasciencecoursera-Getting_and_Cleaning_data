#setwd("~/Coursea/Getting and Cleaning Data/")
# Load data
TrainingData = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
TrainingData[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
TrainingData[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

testingData = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testingData[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testingData[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read features and make the feature names
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge TrainingData and test sets together
MergeData = rbind(TrainingData, testingData)

# Get data on mean and std. dev.
colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2])
# Reduce features to required
features <- features[colsWeWant,]
# Now add  (subject and activity)
colsWeWant <- c(colsWeWant, 562, 563)
MergeData <- MergeData[,colsWeWant]
# Add the column names (features) to MergeData
colnames(MergeData) <- c(features$V2, "Activity", "Subject")
colnames(MergeData) <- tolower(colnames(MergeData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
        MergeData$activity <- gsub(currentActivity, currentActivityLabel, MergeData$activity)
        currentActivity <- currentActivity + 1
}

MergeData$activity <- as.factor(MergeData$activity)
MergeData$subject <- as.factor(MergeData$subject)

tidy = aggregate(MergeData, by=list(activity = MergeData$activity, subject=MergeData$subject), mean)
# Remove the subject and activity column, since a mean of those has no use

tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")
