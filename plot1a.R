#
# plot 1
#
# Question to explore and conditions on exploration
#
# Have total emission from PM25 decreased ?
#
# Restrictions, conditions and other key information
#       use base plotting
#       years 1999, 2002, 2005, 2008

# Setup
library(reshape2)

# Data setup  --    This section would nrmally be a seperate script or function
#                   so that it could be called and not risk a cut and paste error.
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

# Data selection and processing
#
# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the raw data

plot1Melt <- melt(pm25, id="year", measure.vars="Emissions")

#   The recast step takes the melted data and consolidates based on the specified
#       id (year) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Cast the melted data creating a data frame

plot1Data <- dcast(plot1Melt, year ~ variable,sum)

#create a PNG

plotfile = "./figures/plot1a.png"
size = 600
#png(filename = plotfile,
#    width = size,
 #   height = size,
  #  units = "px")

# Create the plot

plot(x = plot1Data$year, 
     y = plot1Data$Emissions,
     xlab = "Year",
     ylab = "Total PM 2.5 Emissions (tons)",
     main = "Decreasing Total PM 2.5 Emissions",
     type = "p",
     col = "red",
     pch = 5,
     lty = 1)

# simple linear regression to show trend
plot1model <- lm(Emissions ~ year, data=plot1Data)

# add the trend line
abline(plot1model,
       lty = 1,
       col = "blue")

# add a legend
legend("bottomleft",
       pch = c(5, NA),
       lty = c(NA,2),
       col = c("red","blue"),
       legend = c("Reported total PM 2.5 emissions",
                  "Trend line"))

dev.off()   #Close the PNG graphics device
