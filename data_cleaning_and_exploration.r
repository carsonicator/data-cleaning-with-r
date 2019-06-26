#!/usr/bin/env Rscript

## Data Exploration and Cleaning:
##   1. Inital Exploration
##     a. Data set dimensions (number of rows and columns)
##     b. Summary of variables
##     c. Identify potential problems
##     d. Quick visualization
##       1. Why visualize? Look at Anscombe’s quartet for an example.
##       2. Observe outlying values
##       3. Observe and understand the shape of the distributions
##   2. Fixing errors
##     a. Identify and deal with missing values
##     b. Look for and remove incorrect data (impossible values, duplicates, typos, and extra spaces)
##     c. Remove irrelevant columns or rows
##    e. Standardize values
##      1. Scaling
##      2. Normalization
##    f. Dimensionality reduction: Can you get rid of any columns?
##      1. High ratio of missing values (based on a determined threshold)
##      2. High correlation with other variable(s)
##      3. Various methods discussed here
##    g. Repeat visualization
##    h. Create a data dictionary or codebook
##      1. Manually (e.g., in a spreadsheet)
##      2. Attach to your dataset [Example with R link here]
##    i. Errors vs. Artifacts


# Load the dataset
# Identifies missing data more accurately. Why is this?
library(readr)
companies <- read_csv("/Users/mbc400/Box Sync/GitHub/data-cleaning-with-r/datasets/company_dataset.csv")


##
## 1) Initial Exploration
##   a. Summary of variables
##   b. Data set dimensions (number of rows and columns)
##   c. Identify potential problems
##   d. Quick visualization
##     1. Why visualize? Look at Anscombe’s quartet for an example.
##     2. Observe outlying values
##     3. Observe and understand the shape of the distributions

# Look at the data frame
View(companies)

# Summarize the data
summary(companies)

# Look at the data structure
str(companies)

# Type of data structure in R
class(companies)

# Data set dimensions
dim(companies)

# Quick Visual Exploration
#
# This helps us get an idea about the distribution of values for different variables and lets us know if we have any outliers
hist(companies$Gross_Income_2013)
boxplot(companies$Num_widgets)

## 2) Fixing Errors
##
##   a. Identify and deal with missing values
##
##      IMPORTANT NOTE: Verify that all missing values are actually missing. If you notice more missing values
##                      than expected, make sure there wasn't a problem at the data import step.

###
# Count the number of missing values
###

# Checking for missing values; returns a logical data frame with TRUE if value is missing, FALSE otherwise 
is.na(companies)

# Returns the number of missing values in each column
sapply(companies, function(x) sum(is.na(x)))

# Returns just columns with missing values
missing_vals <- sapply(companies, function(x) sum(is.na(x)))
missing_vals[missing_vals > 0]

# List all records that have any missing values
companies[!complete.cases(companies),]

###
# Decide what to do with missing values
###

# Ignore
#
# If you choose to ignore missing values remember to use `na.rm = TRUE` for aggregate functions or you will
# get `NA` as a result:
mean(companies$Num_widgets, na.rm=TRUE)

# Exclude
#
# Return all rows with missing values in at least one column
companies[!complete.cases(companies),]

# Create a new data frame containing only rows with no missing data
companies_new <- na.omit(companies)

# Replace
#  
# Eliminate all missing values from a data frame
na.omit(companies)

# Eliminate all missing values from all values in a column
na.omit(companies$Status)

# Replace all NA's in a data frame with '0'
companies[is.na(companies)] <- 0

# Replace all NA's in a data frame column with '0'
companies$Num_widgets[is.na(companies$Num_widgets)] <- 0

# Replace all NA's in a column with the median value of the column
companies$Num_widgets[is.na(companies$Num_widgets)] <- median(companies$Num_widgets)

## 2) Fixing Errors
##
##   b) Look for and remove incorrect data
## 

# Recode impossible values to missing
#
# If you know that a particular range of values for a variable is invalid, you can set those values
# as missing so as not to throw off your analysis later on:
  
# Recode negative (impossible) values in the Num_widgets column to NA
companies$Num_widgets[companies$Num_widgets < 0] <- NA

# Duplicates
#
# Are any of the rows in our data frame duplicated?
# Returns the array index of the first duplicate if any, otherwise 0.
anyDuplicated(companies)

    # a	Dufus & Dingus Ltd.		500000	1	yes	1/1/14 10:00
    # b	Snooty Pants Fashion	silver     	100000	5	  no	1/1/14 13:24
    # b	Snooty Pants Fashion	silver     	100000	5	  no	1/1/14 13:24
    # b	Snooty Pants Fashion	silver     	100000	5	  no	1/1/14 13:24
    # c	Harry Ham Handlers	gold	123409	67	no	1/1/14 15:05

# Logical vector that shows duplicates
duplicated(companies)

# Row indeces of duplicates
# https://stackoverflow.com/questions/12495345/find-indices-of-duplicated-rows
which(duplicated(companies) | duplicated(companies[nrow(companies):1, ],fromLast = TRUE)[nrow(companies):1])

# Works too. Why use the above command?
which(duplicated(companies))

# Create a new data frame of only unique rows
unique_companies <- unique(companies)

# Same using the dplyr package
library(dplyr)
unique_companies <- companies %>% distinct()

# Remove duplicated rows based on duplication in a specific column
companies %>% distinct(Account_Name, .keep_all = TRUE)

# For more details you can use a table to find duplicated values in columns that should contain unique
# values only. Then you can look at the associated full records to see what kind of duplication it is
# (e.g., full row vs. mistakenly entered Account_Name) 

# Lists the values of 'Account_Name' and the number of times they occur
occurrences <- data.frame(table(companies$Account_Name))

# tells you which ids occurred more than once.
occurrences[occurrences$Freq > 1,]

# Returns the records that contain the duplicated 'Account_Name'
companies[companies$Account_Name %in% occurrences$Var1[occurrences$Freq > 1],]

# Typos
#
# Identifiy typos in status categories...
table(companies$Status, useNA = "ifany")

# then fix them
companies$Status[companies$Status == "bornze"] <- "bronze"

# Same for the 'Complete' column
table(companies$Complete, useNA = "ifany")
companies$Complete[companies$Complete == "yess"] <- "yes"
companies$Complete[companies$Complete == "NOT"] <- "no"
