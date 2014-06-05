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
plot5raw <- subset(pm25, fips == "24510")

# find motor vehicle sources.
#   choise to include all motor vehicles (including Planes, Marine Vessels,
#   On and Off road, light and heavy duty).
# EI.Section that starts with Mobile collects all SCC for this.
ListSCC <- SCC$SCC[grep("^Mobile", SCC$EI.Sector )]

# find which observation in pm25 have one of the above SCC codes
listVehicles <- (plot5raw$SCC %in% ListSCC)

# Select the identified observation
plot5raw <- plot5raw[listVehicles,]

# Melt the raw data
plot5Melt <- melt(plot5raw, id="year", measure.vars="Emissions")

# Cast the melted data
plot5cast  <- dcast(plot5Melt, year ~ variable , sum)


#create a PNG
plotfile = "./figures/plot5.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

# Create the plot
plot(x = plot5cast$year, 
     y = plot5cast$Emissions,
     xlab = "Year",
     ylab = "Total PM25 Emissions (tons)",
     main = "Decreasing Total PM25 Emissions
    for motor vehicles in Baltimore City",
     col = "red",
     pch = 5)
# Add a line
lines( x = plot5cast$year, 
       y = plot5cast$Emissions,
       lty = 1,
       col = "red")

# simple linear regression to show trend
plot1model <- lm(Emissions ~ year, data=plot5cast)

# add the trend line
abline(plot1model,
       lty = 2,
       col = "blue")

# add a legend
legend("topright",
       pch = c(5, NA),
       lty = c(1,2),
       col = c("red","blue"),
       legend = c("Reported total PM25 emissions",
                  "Trend line"))
dev.off()
