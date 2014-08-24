# Coursera Getting and Cleaning Data Project

###########################################################
# STEP 0 LOADING DATA
# set of measurement features
features = read.table("UCI HAR Dataset/features.txt", sep=" ")
# activity labels
activities = read.table("UCI HAR Dataset/activity_labels.txt", sep=" ")
# training set
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", sep="\n")
X_train = read.table("UCI HAR Dataset/train/X_train.txt", sep="", strip.white=TRUE, fill=TRUE)
Y_train = read.table("UCI HAR Dataset/train/y_train.txt", sep="\n", fill=TRUE)
# test set
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", sep="\n")
X_test = read.table("UCI HAR Dataset/test/X_test.txt", sep="", strip.white=TRUE, fill=TRUE)
Y_test = read.table("UCI HAR Dataset/test/y_test.txt", sep="\n", fill=TRUE)

###########################################################
# STEP 1 AND 2

# this function will filter out tidy1 the unwanted feature names
comp = function(row){
  if( isTRUE(grep("(mean\\(\\))|(std\\(\\))", row[2]) > 0) ){
    return(row[1])
  }
}
label = function(i){
  return(activities[i,2])
}

# applying function row-wise
keep = apply(X = features, MARGIN = 1, FUN = comp)
# removing null elements
keep[sapply(keep, is.null)] = NULL
# get tidy1 feature labels that we want to keep
keep = features[as.numeric(unlist(keep)),]

# merging X and Y and filtering for std() and mean() 
X_train = X_train[,keep[,1]]
X_test = X_test[,keep[,1]]
train = cbind(cbind(subject_train, X_train), Y_train)
test = cbind(cbind(subject_test, X_test), Y_test)
tidy1 = rbind(train, test)

###########################################################
# STEP 3 adding activity labels
activities[,2] = tolower(activities[,2])
tidy1 = cbind(tidy1, unlist(lapply(tidy1[,68], label)))

###########################################################
# STEP 4 RENAMING FEATURE LABELS

# function to rename features
rename = function(x){
  temp = sub("(f|t)([[:upper:]])(.*?)\\(\\)(.*?)", 
             "\\L\\2\\E\\3\\4", x, perl=TRUE)
  temp = gsub("(.*?)-(.*?)", "\\1_\\2", temp)
  temp = sub("bodyBody", "body", temp)
  temp = sub("gravityAcc", "gravity", temp)
  temp = sub("Acc", "Acceleration", temp)
  temp = sub("Mag", "Magnitude", temp)
  return(temp)
}

# changing feature names to be more readable
keep[,2] = unlist(lapply(keep[,2], rename))
colnames(tidy1) = c("subject", as.vector(keep[,2]), 
                  "activityNumber", "activity")
tidy1$activityNumber = NULL

write.table(tidy1, "tidyData1.txt", row.names=FALSE)

###########################################################
# STEP 5 A second tidy data set with the average of each variable 

tidy2 = with(tidy1, 
             aggregate(tidy1[,!names(tidy1) %in% c("subject","activity")], 
                       by=list(subject,activity), mean))
colnames(tidy2)[c(1,2)] = c("subject","activity")
write.table(tidy2, "tidyData2.txt", row.names=FALSE)