#
# plot 6
#
# Question to explore and conditions on exploration
#
# How have emissions from motor vehicle sources changed from 1990 to 2008
# in Balimore City, MD when compared to Los Angels County, CA?
#
# Restrictions, conditions and other key information
#       years 1999-2008
#       fibs    Baltimore   24510 
#               Los Angles  06037

# Setup
library(reshape2)
library(ggplot2)
library(gridExtra)

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
#   and Los Angeles County, California  ... fips code 06037

plot6raw <- subset(pm25, (fips == "24510" | fips == "06037"))

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

listVehicles <- (plot6raw$SCC %in% ListSCC)

# Select the identified observation

plot6raw <- plot6raw[listVehicles,]

# convert fips codes to names them make them the fips variable a factor
#  the convertion from a numeric to a character will help in the final graph by
#  providing a human readable name to use in the plots.

plot6raw$fips  <- sub("24510","Baltimore City", plot6raw$fips)
plot6raw$fips  <- sub("06037","Los Angeles County", plot6raw$fips)
plot6raw$fips <- as.factor(plot6raw$fips)

# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the data

plot6melt <- melt(plot6raw, id = c("year","fips"), measure.vars="Emissions")

#   The recaste step takes the melted data and consolidates based on the specified
#       id (year and fips) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Recast the data creating a data frame

plot6cast <- dcast(plot6melt, year + fips ~ variable, sum)

# Add another column to the data from that containes the same values as
#   to normalize

plot6cast <- cbind(plot6cast,plot6cast$Emissions)
names(plot6cast)[4] <- "Emissions.Norm"

# normalize the Emission values so by deviding by the first year for each city
#   this should help sow the relative change in each city

city  <- "Baltimore City"

plot6cast$Emissions.Norm[plot6cast$fips == city] <- 
    plot6cast$Emissions.Norm[(plot6cast$fips == city)] /
    plot6cast$Emissions.Norm[((plot6cast$year == min(plot6cast$year[plot6cast$fips == city ])) 
                              & (plot6cast$fips == city))]

city  <- "Los Angeles County"
plot6cast$Emissions.Norm[plot6cast$fips == city] <- 
    plot6cast$Emissions.Norm[(plot6cast$fips == city)] /
    plot6cast$Emissions.Norm[((plot6cast$year == min(plot6cast$year[plot6cast$fips == city ])) 
                              & (plot6cast$fips == city))]

# The plot objects are produced
# make the plot of gross emissions
#   set data for plot

plot6base <- ggplot(plot6cast, aes(year, Emissions))

#   make the plot object
plot6gross <- plot6base +
    geom_point(color = "red") +
    geom_smooth(method = "glm", se = TRUE) +
    theme_bw()+
    facet_grid(.~fips) +
    ggtitle("Total Emissions for Vehicles") +
    ylab("PM 2.5 Emission (tons)")

# make the plot of normilized emissions
#   set data for plot

plot6baseNorm <- ggplot(plot6cast, aes(year, Emissions.Norm))

#   make the plot object
plot6norm <- plot6baseNorm +
    geom_point(color = "red") +
    geom_smooth(method = "glm", se = TRUE) +
    theme_bw()+
    facet_grid(.~fips) +
    ggtitle("Emissions for Vehicles normalized to 1999 levels") +
    ylab("PM 2.5 Emission Normalized to 1999")

#   create a PNG device
plotfile = "./figures/plot6.png"
size = 600
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

print(grid.arrange(plot6gross, 
                   plot6norm, 
                   ncol=1, 
                   main = "Comparison of PM 2.5 Emission for Vehicles
            between Baltimore City & Los Angeles County"))

dev.off()           # close the PNG graphics device
