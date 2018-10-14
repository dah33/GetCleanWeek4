# Week 4 Assignment from Getting and Cleaning Data @ Coursera

library(tidyverse)

# Download and Unzip ------------------------------------------------------

if ( !dir.exists("data-raw") ) {
  dir.create("data-raw")
  src_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(src_file, "data-raw/UCI.zip")
  unzip("data-raw/UCI.zip", exdir = "data-raw")
  file.remove("data-raw/UCI.zip")
}

data_dir <- "data-raw/UCI HAR Dataset/"
train_dir <- paste0(data_dir, "train/")
test_dir  <- paste0(data_dir, "test/")

X_train_file <- paste0(train_dir, "X_train.txt")
y_train_file <- paste0(train_dir, "y_train.txt")
subjects_train_file <- paste0(train_dir, "subject_train.txt")

X_test_file <- paste0(test_dir, "X_test.txt")
y_test_file <- paste0(test_dir, "y_test.txt")
subjects_test_file <- paste0(test_dir, "subject_test.txt")

labels_file <- paste0(data_dir, "activity_labels.txt")
features_file <- paste0(data_dir, "features.txt")

# Load Dimensions ---------------------------------------------------------

labels <- 
  read_delim(labels_file, " ", col_names = c("label_id", "label")) %>% 
  getElement("label")

features_raw <- 
  read_delim(features_file,  " ", col_names = c("feature_id", "feature")) %>% 
  getElement("feature")


# Some feature names aren't unique: add XYZ suffix and apply make.names
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

# Load Features -----------------------------------------------------------
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
#    measurement.
# 4. Appropriately labels the data set with descriptive variable names.

col_positions <- fwf_widths(rep(16, length(features)), features)
col_types <- cols(.default = col_double())
                            
X <- 
  bind_rows(read_fwf(X_train_file, col_positions, col_types),
            read_fwf(X_test_file,  col_positions, col_types)) %>% 
  select_at(vars(matches("mean|std")))

# Load Labels and Subjects ------------------------------------------------
#
# 3. Uses descriptive activity names to name the activities in the data set

y <- labels[c(as.integer(readLines(y_train_file)),
              as.integer(readLines(y_test_file)))]

subjects <- c(as.integer(readLines(subjects_train_file)),
              as.integer(readLines(subjects_test_file)))

# Tidy Data Set -----------------------------------------------------------
#
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

df <- bind_cols(activity = y, subject = subjects, X)

var_avg <- 
  df %>% 
  group_by(activity, subject) %>% 
  summarise_all(mean)

