# How to run the run_analysis.R file
For this analysis you have to first download a row data set and unzip it.
Link to a data set is hier: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
You should unpack a ZIP file into your R working directory, and you should't change
the name of the unziped directory. You can easily find your working directory when
you type getwd() in R console.

# Packages to install
In order to be able to run a run_analysis.R script you have to install the following two 
packages: "data.table" and "reshape2". You can do that by runing the following 
code in your R console:

install.packages(c("data.table", "reshape2"))
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# Running the analysis
After all the previous described steps you should be able to run analysis script,
and you should be able to see a txt file "tidyData.txt" in your working directory.
This txt file contains average of each variable for each activity and each subject.

The run_analysis.R script file is documented, so I don't want to copy/paste the entire 
code. Just open the script and the comments will explain what the script does.