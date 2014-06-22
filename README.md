## Getting and Cleaning Data Project

Matt Masteller

Repo for the submission of the course project for the Johns Hopkins Getting and Cleaning Data course.

### Overview
This project serves to demonstrate the collection and cleaning of a tidy data set that can be used for subsequent
analysis. A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source data for this project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Script

The script contains a function `run.analysis()` that performs the
actual job:
 * downloads raw data (if it doesn't exist already in working directory)
 * reads train and test data sets and merges them
 * processes the merged data set (extract the relevant variables,
   adds descriptive activity names, etc.)
 * writes the merged data set to `rawdata.csv`
 * generates the tidy data set
 * writes the tidy data set to `tidydata.csv`
 * returns the tidy data set

To run the script:

```r
source('./run_analysis.R')
run.analysis() # invoke the function
```

Alternatively, you can download the data archive, extract it, then
run the analysis in multiple steps:

```r
source('./run_analysis.R')
fetch.data() # download data archive
unzip.data() # unzip data archive
run.analysis() # invoke the function
```

*Note*: In the examples above, it is assumed the script file
`run_analysis.R` resides in the current working directory.

### Code book

The CodeBook.md file explains the transformations performed and the resulting data and variables.