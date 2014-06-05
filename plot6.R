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

# Read in data
#   set variables
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zip = "./data/exdata-data-NEI_data.zip"
file1 = "summarySCC_PM25.rds"
file2 = "Source_Classification_Code.rds"

#   check for data directory and for zip file
#       make data directory if not present
#       download data file if not present
if (!file.exists("data")) {dir.create("data")}
if (!file.exists(zip)) {download.file(url = url, destfile = zip)}

#   check if data frame exist and reads the rds file from the zip file if not
if(!exists("pm25")) {pm25  <- readRDS(unzip(zip,file1))}
if (!exists("SCC")) {SCC <- readRDS(unzip(zip,file2))}

# select observation from Baltimore City ... fips code 24510
plot6raw <- subset(pm25, (fips == "24510" | fips == "06037"))

# find motor vehicle sources.
#   choise to include all motor vehicles (including Planes, Marine Vessels,
#   On and Off road, light and heavy duty).
# EI.Section that starts with Mobile collects all SCC for this.
ListSCC <- SCC$SCC[grep("^Mobile", SCC$EI.Sector )]

# find which observation in pm25 have one of the above SCC codes
listVehicles <- (plot6raw$SCC %in% ListSCC)

# Select the identified observation
plot6raw <- plot6raw[listVehicles,]

# convert fips codes to names them make them the fips variable a factor
plot6raw$fips  <- sub("24510","Baltimore City", plot6raw$fips)
plot6raw$fips  <- sub("06037","Los Angeles County", plot6raw$fips)
plot6raw$fips <- as.factor(plot6raw$fips)

# Melt the data
plot6melt <- melt(plot6raw, id = c("year","fips"), measure.vars="Emissions")

# Recast the data
plot6cast <- dcast(plot6melt, year + fips ~ variable, sum)


#create a PNG
plotfile = "./figures/plot6.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

plot6base <- ggplot(plot6cast, aes(year, Emissions))

plot6final <- plot6base +
    geom_point(color = "red") +
    geom_smooth(method = "glm", se = TRUE) +
    theme_bw()+
    facet_grid(.~fips)

print(plot6final)

dev.off()

