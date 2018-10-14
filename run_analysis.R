# Week 4 Assignment from Getting and Cleaning Data @ Coursera
#
# Tasks:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(tidyverse)

# Download and Unzip ------------------------------------------------------

src_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if ( !dir.exists("data-raw") ) {
  dir.create("data-raw")
}
if ( !file.exists("UCI.zip") ) {
  download.file(src, "data-raw/UCI.zip")
  unzip("data-raw/UCI.zip", exdir = "data-raw")
  file.remove("data-raw/UCI.zip")
}

data_dir <- "data-raw/UCI HAR Dataset/"
test_dir  <- paste0(data_dir, "test/")
train_dir <- paste0(data_dir, "train/")

X_test_file <- paste0(test_dir, "X_test.txt")
y_test_file <- paste0(test_dir, "y_test.txt")

X_train_file <- paste0(train_dir, "X_train.txt")
y_train_file <- paste0(train_dir, "y_train.txt")

labels_file <- paste0(data_dir, "activity_labels.txt")
features_file <- paste0(data_dir, "features.txt")

# Load Dimensions ---------------------------------------------------------

labels <- 
  read_delim(labels_file, " ", col_names = c("label_id", "label")) %>% 
  getElement("label")

features_raw <- 
  read_delim(features_file,  " ", col_names = c("feature_id", "feature")) %>% 
  getElement("feature")


# Some feature names aren't unique: add XYZ suffix and make.names
i <- seq_along(features_raw)
suffix <- 
  case_when(
    between(i, 303, 303 + 13) ~ "-X",
    between(i, 317, 317 + 13) ~ "-Y",
    between(i, 331, 331 + 13) ~ "-Z",
    between(i, 382, 382 + 13) ~ "-X",
    between(i, 396, 396 + 13) ~ "-Y",
    between(i, 410, 410 + 13) ~ "-Z",
    between(i, 461, 461 + 13) ~ "-X",
    between(i, 475, 475 + 13) ~ "-Y",
    between(i, 489, 489 + 13) ~ "-Z",
    TRUE ~ ""
    )
features <- 
  paste0(features_raw, suffix) %>% 
  make.names() %>% 
  str_replace_all("[.]+", ".") %>% 
  str_replace_all("[.]+$", "")

col_positions <- fwf_widths(rep(16, length(features)), features)
                            
X_test <- read_fwf(X_test_file, 
                   col_positions, 
                   col_types = cols(.default = col_double()),
                   n_max = 100)
