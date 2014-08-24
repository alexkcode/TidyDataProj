##Coursera Getting and Cleaning Data Project

###Summary
--------------
Run run_analysis.R to produce 2 text files of tidy data sets
called "tidayData1" and "tidyData2" based on physical motion data from 
a wearable device.

###Cleaning Process
--------------
0. The data is first loaded in the first section, along with all
   the variable names, labels, etc.
1. In this step the X and Y datasets and merged and the variables
   are filtered for only the ones that we want. Step 1 and 2 
   from the project description in Coursera are combined to make 
   it simpler for me to code.
   As for my choice of variables to filter, I choose only the ones
   that contain substrings "std()" and "mean()". I interpret only
   those as the ones that are calculated statistics (since "()" 
   often means a function was used).
2. See #1.
3. Here, I just mapped the labels from the "activity_labels.txt" file
   to the numbers in the merged set from #2.
4. In this step I rename variables with a camelCase under_score hybrid
   naming rule. I use camelCase to differentiate words and under_score
   to differentiate semantics more, e.g. measurement,statistic,dimension.
5. The second tidy data set is created in this step, taking the average
   with respect to all row combinations of subject and activity.

###Notes
--------------
* I am using R 3.1.1
* Please make sure UCI HAR Dataset folder is in the same directory
  as the current working one (where run_analysis.R is).