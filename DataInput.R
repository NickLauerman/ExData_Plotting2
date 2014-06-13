#
# DataInput.R
#
# R script to check read 2 rds type files for the second class project for
#   the Exploratory Data Analysis class.
#
# The part of the script checks for item and downloads, creates, extracts or 
#   creates the data frame if it is not present. The check will save processing 
#   time for actions that may already have been created.
#
# 
# Set variables:
#   "url" is the internet locaction and names of the zip file that is supplied 
#       for the course
#   "zip" is the subdirectory and filename that was downloaded fo the assignement
#       the format of this file is a zip file
#   "file1" and "file2" are the file names for the files in the zip acrhaive
#       both files are digital R data sets with the extension rds

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zip = "./data/exdata-data-NEI_data.zip"
file1 = "summarySCC_PM25.rds"
file2 = "Source_Classification_Code.rds"

# Create data structure and download source file
#   check for that the "data" subdirectory and that the zip file is present
#       make data subdirectory if it is not present
#       download the data file if it is not present
if (!file.exists("data")) {dir.create("data")}
if (!file.exists(zip)) {download.file(url = url, destfile = zip)}

# Create data frames if needed.
#   check if data frame exist and reads the rds file from the zip file if not
if(!exists("pm25")) {pm25  <- readRDS(unzip(zip,file1,exdir="./data"))}
if (!exists("SCC")) {SCC <- readRDS(unzip(zip,file2,exdir="./data"))}
