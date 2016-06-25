rm(list = ls())
setwd("/home/simon/DS-3-cleaning/project/UCI")
getwd()

#imports features, activity and training data
features <- read.csv('./features.txt',sep="",header=FALSE); 
#imports activity_labels.txt
activity <- read.csv('./activity_labels.txt',sep="",header=FALSE); 
xtrain <- read.csv("train/x_train.txt", sep = "", header = FALSE)
ytrain <- read.csv("train/y_train.txt",sep = "", header = FALSE)
sub_train <- read.csv("train/subject_train.txt",sep = "", header = FALSE)

# Assign Colomn Names
colnames(activity) <- c("actID","Activity")
colnames(features) <- c("featureID", "Feature")
colnames(sub_train) <- "subID"
colnames(xtrain) <- features[,"Feature"]
colnames(ytrain) <- "actID"

#View(features)
#View(sub_train)


#xtrain <- as.data.frame(xtrain)
#ytrain <- as.data.frame(ytrain)
#sub_train <- as.data.frame(sub_train)


#dim(xtrain)
#dim(ytrain)
#dim(sub_train)



#test data import
xtest <- read.csv("test/x_test.txt", sep = "", header = FALSE)
ytest <- read.csv("test/y_test.txt", sep = "", header = FALSE)
sub_test <- read.csv("test/subject_test.txt",sep = "", header = FALSE)

# column names
colnames(xtest) <- features[,"Feature"]
colnames(ytest) <- "actID"
colnames(sub_test) <- "subID"

# create training data
train <- cbind(ytrain, sub_train,xtrain)

# create test data
test <- cbind(ytest, sub_test, xtest)

# Merging training+test data to train_test
train_test <- rbind(train,test)
#dim(train)
#dim(test)
#dim(train_test)
train_test <- as.data.frame(train_test)
# Col names of merged dataset
col_names <- colnames(train_test)
col_names 

#2. Extract mean & Stdev

selected_cols <- grep("actID|subID|*mean*|*std*", col_names)
length(selected_cols)

train_test <- train_test[selected_cols]


dim(train_test)
dim(activity)

colnames(train_test)
activity
train_test <- merge(train_test, activity,  by='actID')
View(train_test)
col_names <- colnames(train_test)
#col_names

# making titles better and clear
#  Appropriately labels the data set with descriptive variable names.
col_names
col_names <- gsub("\\()", "", col_names)
col_names <-gsub("^t", "Time", col_names)
col_names <-gsub("^f", "Frequency", col_names)
col_names <-gsub("-mean", "Mean", col_names)
col_names <-gsub("-std", "StdDev", col_names)
col_names <-gsub("([Bb]ody[Bb]ody|[Bb]ody)", "Body", col_names)
colnames(train_test) <- col_names
View(train_test)

# creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject
tidy_data <-  aggregate(train_test[,names(train_test) != c('actID','subID','Activity')], by=list(actID = train_test$actID, subID = train_test$subID ),mean)
tidy_data <- tidy_data[,names(train_test) != 'Activity']
View(tidy_data)

# merging activity & tidy data to add activity labels
tidy_data <- merge(tidy_data, activity,  by='actID')

# Save tidy data
write.table(tidy_data, './tidy_data.csv',row.names=TRUE,sep=',')
