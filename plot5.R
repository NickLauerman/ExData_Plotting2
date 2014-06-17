#
# plot 5
#
# Question to explore and conditions on exploration
#
# How have emissions from motor vehicle sources changed from 1990 to 2008
# in Balimore City?
#
# Restrictions, conditions and other key information
#       years 1999-2008
#       fibs 24510

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
# select observation from Baltimore City ... fips code 24510

plot5raw <- subset(pm25, fips == "24510")

# find vehicle sources.
#   choose to include all motor vehicles (including Planes, Marine Vessels,
#   On and Off road, light and heavy duty).
# EI.Section that starts with Mobile collects all SCC for this.
#   EI.Section has higher level groupings however these groupings include some
#   individual SCC that should not be included. Using the short names for the 
#   individual SCC will allow the exclusion for these SCC. The format of the a
#   hierarchical which will allow for excluding several SCC through a single term
#
# Using the Short.Name items that would have been included in the EI.Section 
#   collection are dealt with.
#
#   First tire and break wear are excluded,
#   then SCC for lawn and garden equipment (for example lawn mowers) are excluded,
#   then SCC for agricultural equipment (for example sprayers) are excluded,
#   then SCC for commercial equipment (for example generators) are excluded,
#   then SCC for chain saws and shedders used in logging are excluded,
#   finally SCC for equipment used in underground mining are are excluded.

ListSCC <- SCC$SCC[((grepl("^Mobile", SCC$EI.Sector))
                    & (!grepl("Wear$", SCC$Short.Name))
                    & (!grepl("Lawn & Garden", SCC$Short.Name))
                    & (!grepl("Agricultural Equipt", SCC$Short.Name))
                    & (!grepl("Commercial Equip", SCC$Short.Name))
                    & (!grepl("Logging Equipt /Chain Saws", SCC$Short.Name))
                    & (!grepl("Logging Equipt /Shredders", SCC$Short.Name))
                    & (!grepl("Underground Mining Equipt", SCC$Short.Name)))]

# find which observation in pm25 have one of the above SCC codes

listVehicles <- (plot5raw$SCC %in% ListSCC)

# Select the identified observation

plot5raw <- plot5raw[listVehicles,]

# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the raw data

plot5Melt <- melt(plot5raw, id="year", measure.vars="Emissions")

#   The recast step takes the melted data and consolidates based on the specified
#       id (year) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Cast the melted data creating a data frame

plot5cast  <- dcast(plot5Melt, year ~ variable , sum)

# create the plot file
#   create a PNG device

plotfile = "./figures/plot5.png"
size = 600
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

# Create the plot
plot(x = plot5cast$year, 
     y = plot5cast$Emissions,
     xlab = "Year",
     ylab = "PM 2.5 Emissions (tons)",
     main = "Decreasing Total PM 2.5 Emissions
For Vehicles in Baltimore City",
     type = "b",
     col = "red",
     pch = 5,
     lty = 1)

# simple linear regression to show trend
plot5model <- lm(Emissions ~ year, data=plot5cast)

# add the trend line
abline(plot5model,
       lty = 2,
       col = "blue")

# add a legend
legend("topright",
       pch = c(5, NA),
       lty = c(1,2),
       col = c("red","blue"),
       legend = c("Reported total PM 2.5 emissions",
                  "Trend line"))

dev.off() #close the png graphics device
