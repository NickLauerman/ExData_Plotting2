#
# plot 2
#
# Question to explore and conditions on exploration
#
# Have total emmission of PM25 decreased in the Baltimore City, Maryland area? 
#
# Restrictions, conditions and other key information
#       use base plotting
#       years 1999-2008
#       fips is 24510

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

# select data from fips 24510 (aka Baltimore)

plot2raw <- subset(pm25, fips == "24510")

# melt the selected data
plot2Melt <- melt(plot2raw, id="year", measure.vars="Emissions")

# recast the melt
plot2data <- dcast(plot2Melt, year ~ variable,sum)

#create a PNG
plotfile = "./figures/plot2.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

# Create the plot
plot(x = plot2data$year, 
     y = plot2data$Emissions,
     xlab = "Year",
     ylab = "Total PM 2.5 Emissions (tons)",
     main = "Decreasing Total PM 2.5 Emissions
Baltimore, MA",
     type = "b",
     col = "red",
     pch = 5,
     lty = 1)
# Add a line
#lines( x = plot2data$year, 
#       y = plot2data$Emissions,
#       lty = 1,
#       col = "red")

# simple linear regression to show trend
plot2model <- lm(Emissions ~ year, data=plot2data)

# add the trend line
abline(plot2model,
       lty = 2,
       col = "blue")

# add a legend
legend("bottomleft",
       pch = c(5, NA),
       lty = c(1,2),
       col = c("red","blue"),
       legend = c("Reported total PM 2.5 emissions",
                  "Trend line"))
dev.off()