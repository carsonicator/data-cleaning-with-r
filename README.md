# Data Cleaning and Organization

Data cleaning, processing, and munging can be a very time consuming processes. You can save time by developing a workflow for these tasks. Taking deliberate steps on the front end of your project to properly process your data will...

  1. help you become familiar with your data and any quality issues that may exist, and
  2. save you from headaches down the road.

In this workshop we'll present an outline that you can follow to help you with your day-to-day data organization tasks. Starting with a new, raw, tabular data set, we will follow these steps to learn more about it and clean up where we need to so we analyze it properly:

## Data Cleaning ([R Code](https://github.com/carsonicator/data-cleaning-with-r/blob/master/data_cleaning_and_exploration.r)):
1. Inital Exploration
   1. Data set dimensions (number of rows and columns)
   2. Summary of variables
   3. Identify potential problems
   4. Quick visualization
      1. Why visualize? Look at Anscombe’s quartet for an example.
      2. Observe outlying values
      3. Observe and understand the shape of the distributions
2. Fixing errors
   1. Remove irrelevant columns or rows
   2. Identify and deal with missing values
   3. Look for and remove incorrect data (impossible values, duplicates, typos, and extra spaces)
   4. Errors vs. Artifacts
3. Standardizing values
   1. Scaling
   2. Normalization
4. Dimensionality reduction: Can you get rid of any columns?
   1. High ratio of missing values (based on a determined threshold)
   2. High correlation with other variable(s)
5. Visualizing the cleaned data
6. Writing a cleaned data frame to a .csv file
7. Converting your df to a tibble (optional)

## Data Dictionary ([R Code](https://github.com/carsonicator/data-cleaning-with-r/blob/master/create_data_dictionary.r))
This is usually a list of variables or data elements along with a description of each one (metadata about your data). You’ll want to include things like file name, column id, column name, variable type, count, notes, and warnings to your collaborators regarding any errors or mismatches. It's also a good idea to:

1. Identify variable or columns as categorical, discrete numeric, or continuous
2. Get the overall dimensions of the data set (number of rows and columns)
3. Find out how many instances of each variable there are (total count)

You can create a data dictionary or codebook...
   1. Manually (e.g., in a spreadsheet)
   2. Attach to your dataset (with the [dataMeta](https://cran.r-project.org/web/packages/dataMeta/vignettes/dataMeta_Vignette.html)

## Data Exploration
1. Descriptive Stats
2. Exploratory Data Analysis (EDA)
3. Visual presentation

Note that, when working with your own project data, some of these steps may require you to put the data in context and/or have an understanding of the source domain. If you do not have the domain expertise to determine whether data values make sense, or if you have questions about how the data was collected, you may need to work with a domain expert.
