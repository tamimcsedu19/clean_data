
library(data.table)
#Load the train data

train <- fread('wearable_data/train/X_train.txt')

#Load the column names of train data
train_col_names <- fread('wearable_data/features.txt')

#Coerce the column names to vector
train_col_names <- train_col_names[,V2]

#Set the column names to the data.table train data.
setnames(train,train_col_names)

#Work 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#Select the columns with only 'std' and 'mean'
train_required_cols <- grepl('mean',train_col_names) | grepl('std',train_col_names)

#Assign only the columns to train data
train <- train[,train_required_cols,with=FALSE]


#Uses descriptive activity names to name the activities in the data set
#load the activity labels
activity_labels <- fread('wearable_data/activity_labels.txt')


#load labels for each row
train_row_labels <- fread('wearable_data/train/y_train.txt')


#sapply to replace row_labels with activity names
train_activity_col <- sapply(train_row_labels,function(i) return(activity_labels[i,V2]))

#Appropriately labels the data set with descriptive variable names. 
#Assign this activity to train data
train[,activity:=train_activity_col]

#load the subject
train_subject_col <- fread('wearable_data/train/subject_train.txt')

#Add subject column
train[,subject:=train_subject_col[,V1]]


#Now Compactly do this for the test data
test <- fread('wearable_data/test/X_test.txt')
test_col_names <- fread('wearable_data/features.txt')
test_col_names <- test_col_names[,V2]
setnames(test,test_col_names)
test_required_cols <- grepl('mean',test_col_names) | grepl('std',test_col_names)
test <- test[,test_required_cols,with=FALSE]
#No need to read activity_labels 
#activity_labels <- fread('wearable_data/activity_labels.txt')
test_row_labels <- fread('wearable_data/test/y_test.txt')
test_activity_col <- sapply(test_row_labels,function(i) return(activity_labels[i,V2]))
test[,activity:=test_activity_col]
test_subject_col <- fread('wearable_data/test/subject_test.txt')
test[,subject:=test_subject_col[,V1]]



#Merge the two datasets
#Merges the training and the test sets to create one data set.
data <- rbind(train,test)

#Create the new tidy data set 

#get the column names
col_names <- names(data)

#Discard the columns named activity and subject
col_names <- col_names[col_names != 'activity' & col_names!='subject']

#Append an 'avg' to each col names
new_col_names <- sapply(col_names,function(x) return(paste('avg',x, sep = "_")))

#Create the new tidy data set 
tidy_data <- data[,lapply(.SD,mean),by="activity,subject",.SDcols=col_names]

#rename the columns to reflect the new average of each values
setnames(tidy_data,old=col_names,new=new_col_names)

#write the tidy Data
write.table(tidy_data,'tidy_avg_data')
