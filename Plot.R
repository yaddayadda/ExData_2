library(plyr)
setwd("Users/AM706/Dev/coursera/r_programming/src/assignments/EPA_exploratory_analysis_assignment2")
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
