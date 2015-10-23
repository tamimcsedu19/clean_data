# clean_data

## The process of cleaning data is simple.

### I renamed the data directory as wearable_data


#### The merging process is final process

#####The steps I performed train data are 

* First read the data in data.table variable 'train'
* Read features.txt for column names
* Set the column names with setnames function
* Extract only the mean and std_dev columns with grepl
* Read activity label -> name file named activity_labels.txt
* Read the activity file y_train.txt
* Rename with descriptive activity name with sapply
* add the column to data.table train
* Then add the subject column from subject_test.txt
* Repeat the process for test data but this time the data.table variable name is 'test'
* Merge test and train data with rbind
* lapply mean function to all the columns grouped by activity and subject
* rename the column names to contain an 'avg_' in front so that it is recognized 
