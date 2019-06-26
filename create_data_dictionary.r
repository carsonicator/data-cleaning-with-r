#!/usr/bin/env Rscript

# Run with 'Rscript create_data_dictionary.r'

##  Create a data dictionary or codebook
##    a. Manually (e.g., in a spreadsheet)
##    b. Attach to your dataset using the dataMeta package

# Data Dictionary
# This is usually a list of variables or data elements along with a description of each one (metadata about your data).
# You’ll want to include things like file name, column id, column name, variable type, count, notes, and warnings to
# your collaborators regarding any errors or mismatches.
#
#  1. Identify categorical and continuous variables
#  2. Get the overall dimensions of the data set (number of rows and columns)
#  3. Find out how many instances of each variable there are (total count)
#
# You can use the R package [dataMeta](https://cran.r-project.org/web/packages/dataMeta/vignettes/dataMeta_Vignette.html)
# to create a data dictionary and attach it to your dataset. Here's a demonstration with our test set
  
library(dataMeta)

#erase after testing
companies <- read.csv("/Users/mbc400/Box Sync/GitHub/data-cleaning-with-r/output/companies_cleaned.csv", header = TRUE, stringsAsFactors = FALSE)

### Three steps
##
# Step 1: Build a linker data frame
##
# Add a description for each variable name and identify the type
var_desc <- c("Account number", "Company name", "Current award level status", "2013 gross income", "Number of widgets the company created in 2013", "Is their record in our system complete or not?", "Last time the record was updated")

# Variable types can be:
# 0: can be displayed as a range of values
# 1: descriptive or categorical variables  
var_type <- c(0, 0, 1, 0, 0, 1, 0)

# Build the linker data frame
linker <- build_linker(my.data = companies, variable_description = var_desc, variable_type = var_type)
linker

##
# Step 2: Build the data dictionary using the data + the linker
##

# For this data set, no further option description is needed.
dictionary <- build_dict(my.data = companies, linker = linker, option_description = NULL, prompt_varopts = FALSE)

# Create main_string for attributes
main_string <- "This dataset describes several companies' award statuses, income, and productivity in 2013."
complete_dataset <- incorporate_attr(my.data = companies, data.dictionary = dictionary,
                                     main_string = main_string)

# Just the dictionary...
attr(complete_dataset, "dictionary")
# or...
attributes(complete_dataset)$dictionary

# Write the dictionary and dataset + dictionary to output files:

library(lubridate)
library(forcats)

# Change columns to appropriate types before writing to file
complete_dataset$Date = mdy_hm(complete_dataset$Date)
complete_dataset$Status = as_factor(complete_dataset$Status)
complete_dataset$Complete = as_factor(complete_dataset$Complete)

# Export dictionary only:
dict_only <- attributes(complete_dataset)$dictionary
write.csv(dict_only, "/Users/mbc400/Box Sync/GitHub/data-cleaning-with-r/output/companies_cleaned_dict_only.csv")

# Save as an R dataset, .rds (dataset with appended dictionary)
save_it(complete_dataset, name_of_file = "/Users/mbc400/Box Sync/GitHub/data-cleaning-with-r/output/companies_cleaned_with_dict")
