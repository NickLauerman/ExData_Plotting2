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

#########################
#
# uncomment this when completed. Data already loaded to same time.
#
#########################

#pm25  <- readRDS("./data/summarySCC_PM25.rds")

# Melt the data frame
plot1Melt <- melt(pm25, id="year", measure.vars="Emissions")

# Recast the data summing the emmissions by year
plot1Data <- dcast(plot1Melt, year ~ variable,sum)

######################
#
# and details to create PNG image
#
#########################

# Create the plot
plot(x = plot1Data$year, 
     y = plot1Data$Emissions,
     xlab = "Year",
     ylab = "Total PM25 Emissions (tons)",
     main = "Decreasing Total PM25 Emissions",
     col = "red",
     pch = 5)
# Add a line
lines( x = plot1Data$year, 
       y = plot1Data$Emissions,
       lty = 1,
       col = "red")

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
       legend = c("Reported total PM25 emissions",
                  "Trend line"))
