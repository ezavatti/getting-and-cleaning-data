
#Read data


#Unzip data

# load reshape2
# install dplyr
# If your dplyr version is not at least 0.4.0, then you should hit the Esc key now, reinstall dplyr

# GET DATA for X_test

X_test <-read.table(file="./UCI HAR Dataset/test/X_test.txt",header = FALSE)

# Get data for X_train

X_train <-read.table(file="./UCI HAR Dataset/train/X_train.txt",header = FALSE)

#Get data for y_test (activity by subjects in test)

y_test <-read.table(file="./UCI HAR Dataset/test/y_test.txt",header = FALSE)

# Get data for y_train (activity by subjects in train)

y_train <-read.table(file="./UCI HAR Dataset/train/y_train.txt",header = FALSE)

# Get data for subjects_test

subject_test <-read.table(file="./UCI HAR Dataset/test/subject_test.txt",header = FALSE)

# Get data for subjects_train

subject_train <-read.table(file="./UCI HAR Dataset/train/subject_train.txt",header = FALSE)

#Get data for Activity_labels

activity <-read.table(file="./UCI HAR Dataset/activity_labels.txt",header = FALSE)
activity[,2]<- as.character(activity[,2])



colnames(activity)<- c("Test", "Activity")


# Merge y_train and y_test row-wise into Y_merged

Y_merged <- rbind(y_train, y_test)

# Change name of colum in Y_merged to "Activity"

colnames(Y_merged)<- c("Test")

Y_merged$Activity = activity$Activity[match(Y_merged$Test, activity$Test)]

#Merge subject_test and subject_train row-wise into a file called: Subject_Merged

Subject_Merged<- rbind(subject_train, subject_test)

#Change name of the column in Subject_Merged with: Subject

colnames(Subject_Merged)<- "Subject"

#Get data for features

features <-read.table(file="./UCI HAR Dataset/features.txt",header = FALSE)

# Transpose the features database

featuresrow<- t(features)

# Merge row-wise X_train and X_test into X_merged

X_merged<- rbind(X_train[,],X_test[,])

#Change the columns' names of the merged data with features file

colnames(X_merged)<- featuresrow[2,]

#Merge column-wise Subject_Merged, Y_Merged, 

total<- cbind(Subject_Merged, Y_merged[,"Activity"], Y_merged[,"Test"], X_merged)


colnames(total)[2]<- "Activity"

colnames(total)[3]<- "Activity code"

# total$Subject<- as.data.frame(total$Subject)

# total$Activity<- as.data.frame(total$Activity)

#Extracting only the measurements on the mean and standard deviation for each measurement

# o_mean_std<- melt(total, id = c("Subject", "Activity", measure.vars = c(colnames(total)[grep("mean",colnames(total))], colnames(total)[grep("std",colnames(total))])))

# o_mean_std<- total[,c(colnames(total)[grep("mean",colnames(total))], colnames(total)[grep("std",colnames(total))])]

o_mean_std<- total[,c("Subject", "Activity", colnames(total)[grep("mean",colnames(total))], colnames(total)[grep("std",colnames(total))])]

# colnames(o_mean_std)[2]<- "Activity"
# colnames(o_mean_std)[1]<- "Subject"

# Getting tidy data : mean of measurement by Subject and Activity
final_mean<-aggregate(.~ Activity + Subject, data= o_mean_std, mean)
