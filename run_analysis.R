library(base)
library(utils)
library(data.table)

data.url  <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
data.file <- 'dataset.zip'
data.dir  <- 'UCI HAR Dataset/'

# fetch.data downloads the UCI HAR data set:
# "Human Activity Recognition Using Smartphones Data Set" 
# see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
fetch.data <- function () {
	message('fetching data...')
	download.file(data.url, destfile = data.file, method = 'curl')
}

unzip.data <- function () {
	message('unzipping data...')
	unzip(data.file)
}

# load.data loads and processes a UC train or a test data set
load.data <- function (set, features, labels) {
	# construct the relative paths to data files
	prefix <- paste(set, '/', sep = '')
	file.data <- paste(prefix, 'X_', set, '.txt', sep = '')
	file.label <- paste(prefix, 'y_', set, '.txt', sep = '')
	file.subject <- paste(prefix, 'subject_', set, '.txt', sep = '')

	# read the data into a data.frame and then transform it into data.table
	data <- read.table(file.data)[, features$index]
	names(data) <- features$name

	label.set <- read.table(file.label)[, 1]
	data$label <- factor(label.set, levels=labels$level, labels=labels$label)

	subject.set <- read.table(file.subject)[, 1]
	data$subject <- factor(subject.set)

	# convert to data table
	data.table(data)
}

# fix.variables replaces header variable names for tidy data
fix.variables <- function (dataset) {
    names <- names(dataset)
    names <- gsub('-mean', 'Mean', names) 		# replace "-mean" with "Mean"
    names <- gsub('-std', 'Std', names) 		# replace "-std" with "Std"
    names <- gsub('[()-]', '', names) 			# remove parenthesis and dashes
    names <- gsub('BodyBody', 'Body', names) 	# Replace "BodyBody" with "Body"
    setnames(dataset, names)
	dataset
}

run.analysis <- function () {
	# unzipped data exists
    if(file.exists(paste(data.dir,'features.txt',sep=''))){
		# if uncompressed data exists already, skip fetch/unzip
	} else if (file.exists(data.file)) {
		# if compressed data exists already, skip fetch
		unzip.data()	
	} else {
		# if no data exists, fetch and unzip
		fetch.data()
		unzip.data()	
	}
	
	# set working directory
	setwd(data.dir)
	
	# get all feature names
	feature.set <- read.table('features.txt', col.names = c('index', 'name'))
	# get "mean" and "std" feature names
	features <- subset(feature.set, grepl('-(mean|std)[(]', feature.set$name))

	# get the labels
	label.set <- read.table('activity_labels.txt', col.names = c('level', 'label'))

	# load train and test data sets
	message('loading train data...')
	train.set <- load.data('train', features, label.set)
	message('loading test data...')
	test.set <- load.data('test', features, label.set)

	# the raw data set
	dataset <- rbind(train.set, test.set)
	
	# generate the tidy data set
	message('creating tidy dataset...')
	tidy.dataset <- dataset[, lapply(.SD, mean), by=list(label, subject)]
	# fix the variable names
	tidy.dataset <- fix.variables(tidy.dataset)

	# write the raw and the tidy data sets to files
	setwd('..')
	write.csv(dataset, file = 'rawdata.csv', row.names = FALSE)
	write.csv(tidy.dataset, file = 'tidydata.csv', row.names = FALSE, quote = FALSE)

	# return the tidy data set
	message('done.')
	tidy.dataset
}