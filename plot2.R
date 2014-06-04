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

#########################
#
# uncomment this when completed. Data already loaded to same time.
#
#########################

#pm25  <- readRDS("./data/summarySCC_PM25.rds")

# select data from fips 24510 (aka Baltimore)

plot2raw <- subset(pm25, fips == "24510")

# melt the selected data
plot2Melt <- melt(plot2raw, id="year", measure.vars="Emissions")

# recast the melt
plot2data <- dcast(plot2Melt, year ~ variable,sum)


######################
#
# add details to create PNG image
#
#########################

# Create the plot
plot(x = plot2data$year, 
     y = plot2data$Emissions,
     xlab = "Year",
     ylab = "Total PM25 Emissions (tons)",
     main = "Decreasing Total PM25 emissions
Baltimore, MA",
     col = "red",
     pch = 5)
# Add a line
lines( x = plot2data$year, 
       y = plot2data$Emissions,
       lty = 1,
       col = "red")

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
       legend = c("Reported total PM25 emissions",
                  "Trend line"))
