#!/usr/bin/env Rscript

# Run with 'Rscript data_cleaning_and_exploration.r'

## Data Cleaning and Standardization:
##   1. Inital Exploration
##     a. Data set dimensions (number of rows and columns)
##     b. Summary of variables
##     c. Identify potential problems
##     d. Quick visualization
##       1. Why visualize? Look at Anscombe’s quartet for an example.
##       2. Observe outlying values
##       3. Observe and understand the shape of the distributions
##   2. Fixing errors
##     a. Remove irrelevant columns or rows
##     b. Identify and deal with missing values
##     c. Look for and remove incorrect data (impossible values, duplicates, typos, and extra spaces)
##     d. Errors vs. Artifacts
##   3. Standardize values
##      a. Scaling (changing the range of data)
##      b. Normalization
##   4. Dimensionality reduction: Can you get rid of any columns?
##      a. High ratio of missing values (based on a determined threshold)
##      b. High correlation with other variable(s)
##      c. Various methods discussed here
##   5. Repeat visualization
##   6. Write a cleaned data frame to a .csv file
##   7. Convert your df to a tibble
##
## Data Exploration:
##   1. Descriptive Stats
##   2. Exploratory Data Analysis (EDA)
##   3. Visual presentation

# Load the dataset
# Identifies missing data more accurately. Why is this?
library(readr)
companies <- read_csv("/Users/mbc400/Box Sync/GitHub/data-cleaning-with-r/datasets/company_dataset.csv")


##
## 1. Initial Exploration
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


## 2. Fixing Errors
##
##   a. Remove irrelevant columns or rows
##

# Add some content here

## 2. Fixing Errors
##
##   b. Identify and deal with missing values
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

## 2. Fixing Errors
##
##   c. Look for and remove incorrect data (impossible values, duplicates, typos, and extra spaces)
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

    # a	ABC Ltd.	                  	500000	1    yes 1/1/14 10:00
    # b	Forward Fashion	    silver     	100000	5    no  1/1/14 13:24
    # b	Forward Fashion	    silver     	100000	5    no  1/1/14 13:24
    # b	Forward Fashion	    silver     	100000	5    no  1/1/14 13:24
    # c	Finance Wizard      gold	    123409	67   no  1/1/14 15:05

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

# Removing Extra Spaces
#
# Eliminate all leading and trailing white space from every value in the data frame
# sapply returns a matrix, so we have to cast companies_no_ws back as a data frame.
companies_no_ws <- as.data.frame(sapply(companies, function(x) trimws(x)), stringsAsFactors = FALSE)

# Works on columns
# Removes leading and trailing white space from specific columns
library(stringr)
companies$Complete <- str_trim(companies$Complete)

# Remove extra spaces within account names
companies$Account_Name <- gsub("\\s+"," ", companies$Account_Name)

# Fixing case issues with categorical data
#
# Look at the different status categories again...
table(companies$Status, useNA = "ifany")

# ...and change them all to lower case
companies$Status <- sapply(companies$Status, tolower)

# check your work
table(companies$Status, useNA = "ifany")


## 2. Fixing Errors
##
##   d. Errors vs. Artifacts
##

# Sometimes during the import, organization, or cleaning stages of a project you inadvertantly introduce
# artifacts into your data. For example, when you import data in Excel it sometimes chooses the wrong data
# type for one or more of your columns (assigning a column with eight digit numeric values as type 'date').
# Keep this in mind so you don't carry these artifacts into your analysis steps.


## 3. Standardize values
##
##   a. Scaling (changing the range of data)
##

# https://www.thekerneltrip.com/statistics/when-scale-my-data/
# Scaling vs. normalization: https://www.quora.com/When-should-you-perform-feature-scaling-and-mean-normalization-on-the-given-data-What-are-the-advantages-of-these-techniques

# If you want to compare columns that are on a different scale, you need to change both sets of values to
# use a common scale. Algorithms such as SVM and KNN treat a change of '1' in a value with the same importance.

# https://stackoverflow.com/questions/15215457/standardize-data-columns-in-r
dat <- data.frame(x = rnorm(10, 30, .2), y = runif(10, 3, 5))
scaled.dat <- scale(dat)

# check that we get mean of 0 and sd of 1
colMeans(scaled.dat)  # faster version of apply(scaled.dat, 2, mean)
apply(scaled.dat, 2, sd)


## 3. Standardize values
##
##   b. Normalization (changing the shape of the distribution of the data)
##

# Needed when running algorithms that assume a normal distribution such as t-test, ANOVA, linear regression,
# LDA, and Gaussian Naive Bayes.
# We can make a "right-skewed" variable in the following manner:
# [a] drawing from a (standard)-normal distribution, and then:
# [b] exponentiating the results

x <- exp(rnorm(100,0,1))  # Combined [a] and [b]

hist(x)           # Plot the original right-skewed variable;
hist(log(x))      # plot the logged-version of the variable.


##   4. Dimensionality reduction: Can you get rid of any columns?
##      a. High ratio of missing values (based on a determined threshold)
##      b. High correlation with other variable(s)
##      c. Various methods discussed here

## 5. Repeat visualization

library(ggplot2)
ggplot(companies, aes(x = Status, fill = Complete)) + geom_bar()

## 6. Write a cleaned data frame to a .csv file
write.csv(companies, "/Users/mbc400/Box Sync/GitHub/data-cleaning-with-r/output/companies_cleaned.csv", row.names = FALSE)

## 7. Convert your data frame to a tibble

# With the 'dplyr' package, you can convert your data from to a tibble
companies_tbl <- as_tibble(companies_cleaned)
companies_tbl

# Check out the newly created tibble with 'glimpse'
glimpse(companies_tbl)

# Convert back to a data frame if you like
companies_cleaned <- as.data.frame(companies_tbl)

# test
median_gross <- companies %>%
  summarize (median_gross = median(Gross_Income_2013))
