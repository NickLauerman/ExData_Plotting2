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

# Read in data
#   set variables
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zip = "./data/exdata-data-NEI_data.zip"
file1 = "summarySCC_PM25.rds"

#   check for data directory and for zip file
#       make data directory if not present
#       download data file if not present
if (!file.exists("data")) {dir.create("data")}
if (!file.exists(zip)) {download.file(url = url, destfile = zip)}

#   check if data frame exist and reads the rds file from the zip file if not
if(!exists("pm25")) {pm25  <- readRDS(unzip(zip,file1, exdir="./data"))}

# Melt the data frame
plot1Melt <- melt(pm25, id="year", measure.vars="Emissions")

# Recast the data summing the emmissions by year
plot1Data <- dcast(plot1Melt, year ~ variable,sum)

#create a PNG
plotfile = "./figures/plot1.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

# Create the plot
plot(x = plot1Data$year, 
     y = plot1Data$Emissions,
     xlab = "Year",
     ylab = "Total PM 2.5 Emissions (tons)",
     main = "Decreasing Total PM 2.5 Emissions",
     type = "b",
     col = "red",
     pch = 5,
     lty = 1)
# Add a line
#lines( x = plot1Data$year, 
#       y = plot1Data$Emissions,
#       lty = 1,
#       col = "red")

# simple linear regression to show trend
plot1model <- lm(Emissions ~ year, data=plot1Data)

# add the trend line
abline(plot1model,
       lty = 2,
       col = "blue")

# add a legend
legend("bottomleft",
       pch = c(5, NA),
       lty = c(1,2),
       col = c("red","blue"),
       legend = c("Reported total PM 2.5 emissions",
                  "Trend line"))
#turn off graphics device
dev.off()
