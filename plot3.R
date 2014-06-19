#
# plot 3
#
# Question to explore and conditions on exploration
#
# Which emission types have increase and decreased in Baltimore
# during the perios of 1999-2008
#
# Restrictions, conditions and other key information
#       use ggplot2 package
#       years 1999-2008
#       fips is 24510

# Setup
library(reshape2)
library(ggplot2)

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
# select data from fips 24510 (aka Baltimore)

plot3raw <- subset(pm25, fips == "24510")

# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the raw data

plot3melt  <- melt(plot3raw, id=c("year","type") , measure.vars="Emissions")

#   The recast step takes the melted data and consolidates based on the specified
#       id (year and type) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Cast the melted data creating a data frame

plot3cast <- dcast(plot3melt, year + type ~ variable, sum)

# make the plot

#   set data for plot
plot3base  <-  ggplot(plot3cast, aes(year,Emissions))

#   make the plot object
plot3final<- plot3base  + 
    geom_point(color = "red") + 
    facet_grid(. ~ type) + 
    geom_smooth(method = "lm", se = FALSE) + 
    theme_bw() +
    ggtitle(expression(paste("Tends of ",
                             PM[~2.5],
                             " Emission by Emision Type for Baltimore City"))) +
    ylab(expression(paste(PM[~2.5]," Emission (tons)")))

#create a PNG device
plotfile = "./figures/plot3.png"
png(filename = plotfile,
    width = 2000,
    height = 500,
    units = "px")

print(plot3final)   #print the plot

dev.off()           #close the PNG graphics device