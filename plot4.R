#
# plot 4
#
# Question to explore and conditions on exploration
#
# Has pm25 emissions due to coal combustion related sources changed from
# 1999 - 2008?
#
# Restrictions, conditions and other key information
#       years 1999-2008


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
if(!exists("pm25")) {pm25  <- readRDS(unzip(zip,file1,exdir="./data"))}
if (!exists("SCC")) {SCC <- readRDS(unzip(zip,file2,exdir="./data"))}

# Extract the observation on Coal
#find SCC's were the EI.Sector contain the word coal or Coal
ListSCC <- SCC$SCC[grep("[Cc]oal", SCC$EI.Sector )]
#Find which observation in pm25 have one of the above SCCs (meaning contain coal)
listCoal <- (pm25$SCC %in% ListSCC)
# Select the needed obervatins
plot4raw <- pm25[listCoal,] 

# Melt the raw data
plot4Melt <- melt(plot4raw, id="year", measure.vars="Emissions")

# Cast the melted data
plot4cast  <- dcast(plot4Melt, year ~ variable , sum)

#create a PNG
plotfile = "./figures/plot4.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

# Create the plot
plot(x = plot4cast$year, 
     y = plot4cast$Emissions,
     xlab = "Year",
     ylab = "PM 2.5 Emissions (tons)",
     main = "Decreasing Total PM 2.5 Emissions
for Coal",
     type = "b",
     col = "red",
     pch = 5,
     lty = 1)
# Add a line
#lines( x = plot4cast$year, 
#       y = plot4cast$Emissions,
#       lty = 1,
#       col = "red")

# simple linear regression to show trend
plot4model <- lm(Emissions ~ year, data=plot4cast)

# add the trend line
abline(plot4model,
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