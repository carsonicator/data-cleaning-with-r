# Data Cleaning and Organization

Data cleaning, processing, and munging can be a very time consuming processes. You can save time by developing a workflow for these tasks that you can apply for each data set you need to process. Taking deliberate steps on the front end of your project to properly process your data will help you:

1. become familiar with your data and any quality issues that may exist, and
2. may save you from headaches down the road because you missed something important.

In this workshop we'll present an outline that you can follow to help you with your day-to-day data organization tasks. When working with your own project data, some of these steps may require you to put the data in context and/or have an understanding of the source domain. If you do not have the domain expertise to determine whether data values make sense, or if you have questions about how the data was collected, you need to work with a domain expert.

Starting with a new, raw, tabular data set, we will follow these steps to learn more about it and clean up where we need to so we analyze it properly:

## Outline:
1. Inital Exploration
   1. Data set dimensions (number of rows and columns)
   2. Summary of variables
   3. Identify potential problems
   4. Quick visualization
      1. Why visualize? Look at Anscombe’s quartet for an example.
      2. Observe outlying values
      3. Observe and understand the shape of the distributions
2. Fixing errors
   1. Identify and deal with missing values
   2. Look for and remove incorrect data (impossible values, duplicates, typos, and extra spaces)
   3. Remove irrelevant columns or rows
   4. Standardize values
      1. Scaling
      2. Normalization
   5. Dimensionality reduction: Can you get rid of any columns?
      1. High ratio of missing values (based on a determined threshold)
      2. High correlation with other variable(s)
      3. Various methods discussed here
   6. Repeat visualization
   7. Errors vs. Artifacts
3. Create a data dictionary or codebook
   1. Manually (e.g., in a spreadsheet)
   2. Attach to your dataset (with the [dataMeta](https://cran.r-project.org/web/packages/dataMeta/vignettes/dataMeta_Vignette.html) package)
4. Getting our dataset ready for the Tidyverse
