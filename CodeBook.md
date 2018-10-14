---
title: "CodeBook"
author: "Dan Houghton"
date: "14/10/2018"
output: 
  html_document: 
    keep_md: yes
---



## Source Data

This data was collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available [at the source website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), but in summary:

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

See [`data-raw/UCI HAR Dataset/features.txt`](data-raw/UCI HAR Dataset/features.txt) for more details of the measurements.

Each record of the source data consists of:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label: `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, or `LAYING`
- An identifier of the subject who carried out the experiment.

These are split across several files.

## Transformations

I made the follow transformations:

1. Merged the training and the test sets to create one data set.
2. Selected only the variables (features) relating to the mean and standard deviation of the underlying measurements.
3. Added the activity and subject variables.
4. Ensured the variable names were R-friendly.
5. Create a second, independent tidy data set [`results.txt`](results.txt) with the average of each variable per activity, per subject.

## Variables

The averaged variables per `<activity, subject>` pair are:


```r
select(var_avg, -activity, -subject) %>% names()
```

```
##  [1] "tBodyAcc.mean.X"                    
##  [2] "tBodyAcc.mean.Y"                    
##  [3] "tBodyAcc.mean.Z"                    
##  [4] "tBodyAcc.std.X"                     
##  [5] "tBodyAcc.std.Y"                     
##  [6] "tBodyAcc.std.Z"                     
##  [7] "tGravityAcc.mean.X"                 
##  [8] "tGravityAcc.mean.Y"                 
##  [9] "tGravityAcc.mean.Z"                 
## [10] "tGravityAcc.std.X"                  
## [11] "tGravityAcc.std.Y"                  
## [12] "tGravityAcc.std.Z"                  
## [13] "tBodyAccJerk.mean.X"                
## [14] "tBodyAccJerk.mean.Y"                
## [15] "tBodyAccJerk.mean.Z"                
## [16] "tBodyAccJerk.std.X"                 
## [17] "tBodyAccJerk.std.Y"                 
## [18] "tBodyAccJerk.std.Z"                 
## [19] "tBodyGyro.mean.X"                   
## [20] "tBodyGyro.mean.Y"                   
## [21] "tBodyGyro.mean.Z"                   
## [22] "tBodyGyro.std.X"                    
## [23] "tBodyGyro.std.Y"                    
## [24] "tBodyGyro.std.Z"                    
## [25] "tBodyGyroJerk.mean.X"               
## [26] "tBodyGyroJerk.mean.Y"               
## [27] "tBodyGyroJerk.mean.Z"               
## [28] "tBodyGyroJerk.std.X"                
## [29] "tBodyGyroJerk.std.Y"                
## [30] "tBodyGyroJerk.std.Z"                
## [31] "tBodyAccMag.mean"                   
## [32] "tBodyAccMag.std"                    
## [33] "tGravityAccMag.mean"                
## [34] "tGravityAccMag.std"                 
## [35] "tBodyAccJerkMag.mean"               
## [36] "tBodyAccJerkMag.std"                
## [37] "tBodyGyroMag.mean"                  
## [38] "tBodyGyroMag.std"                   
## [39] "tBodyGyroJerkMag.mean"              
## [40] "tBodyGyroJerkMag.std"               
## [41] "fBodyAcc.mean.X"                    
## [42] "fBodyAcc.mean.Y"                    
## [43] "fBodyAcc.mean.Z"                    
## [44] "fBodyAcc.std.X"                     
## [45] "fBodyAcc.std.Y"                     
## [46] "fBodyAcc.std.Z"                     
## [47] "fBodyAcc.meanFreq.X"                
## [48] "fBodyAcc.meanFreq.Y"                
## [49] "fBodyAcc.meanFreq.Z"                
## [50] "fBodyAccJerk.mean.X"                
## [51] "fBodyAccJerk.mean.Y"                
## [52] "fBodyAccJerk.mean.Z"                
## [53] "fBodyAccJerk.std.X"                 
## [54] "fBodyAccJerk.std.Y"                 
## [55] "fBodyAccJerk.std.Z"                 
## [56] "fBodyAccJerk.meanFreq.X"            
## [57] "fBodyAccJerk.meanFreq.Y"            
## [58] "fBodyAccJerk.meanFreq.Z"            
## [59] "fBodyGyro.mean.X"                   
## [60] "fBodyGyro.mean.Y"                   
## [61] "fBodyGyro.mean.Z"                   
## [62] "fBodyGyro.std.X"                    
## [63] "fBodyGyro.std.Y"                    
## [64] "fBodyGyro.std.Z"                    
## [65] "fBodyGyro.meanFreq.X"               
## [66] "fBodyGyro.meanFreq.Y"               
## [67] "fBodyGyro.meanFreq.Z"               
## [68] "fBodyAccMag.mean"                   
## [69] "fBodyAccMag.std"                    
## [70] "fBodyAccMag.meanFreq"               
## [71] "fBodyBodyAccJerkMag.mean"           
## [72] "fBodyBodyAccJerkMag.std"            
## [73] "fBodyBodyAccJerkMag.meanFreq"       
## [74] "fBodyBodyGyroMag.mean"              
## [75] "fBodyBodyGyroMag.std"               
## [76] "fBodyBodyGyroMag.meanFreq"          
## [77] "fBodyBodyGyroJerkMag.mean"          
## [78] "fBodyBodyGyroJerkMag.std"           
## [79] "fBodyBodyGyroJerkMag.meanFreq"      
## [80] "angle.tBodyAccMean.gravity"         
## [81] "angle.tBodyAccJerkMean.gravityMean" 
## [82] "angle.tBodyGyroMean.gravityMean"    
## [83] "angle.tBodyGyroJerkMean.gravityMean"
## [84] "angle.X.gravityMean"                
## [85] "angle.Y.gravityMean"                
## [86] "angle.Z.gravityMean"
```

For detailed definitions, please refer to [`data-raw/UCI HAR Dataset/features_info.txt`](data-raw/UCI HAR Dataset/features_info.txt).
