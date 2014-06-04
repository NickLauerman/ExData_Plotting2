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

#########################
#
# uncomment this when completed. Data already loaded to same time.
#
#########################

#pm25  <- readRDS("./data/summarySCC_PM25.rds")
#SCC <- readRDS("./data/Source_Classification_Code.rds")

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


######################
#
# add details to create PNG image
#
#########################


# Create the plot
plot(x = plot4cast$year, 
     y = plot4cast$Emissions,
     xlab = "Year",
     ylab = "Total PM25 Emissions (tons)",
     main = "Decreasing Total PM25 Emissions
    for Coal",
     col = "red",
     pch = 5)
# Add a line
lines( x = plot4cast$year, 
       y = plot4cast$Emissions,
       lty = 1,
       col = "red")

# simple linear regression to show trend
plot1model <- lm(Emissions ~ year, data=plot4cast)

# add the trend line
abline(plot1model,
       lty = 2,
       col = "blue")

# add a legend
legend("bottomleft",
       pch = c(5, NA),
       lty = c(1,2),
       col = c("red","blue"),
       legend = c("Reported total PM25 emissions",
                  "Trend line"))
