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

# Data setup
#   This is done in a seperate script "DataInput.R"
source("DataInput.R")

# Data selection and processing
#
# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the raw data
plot1Melt <- melt(pm25, id="year", measure.vars="Emissions")
#   The recast step takes the melted data and consolidates based on the specified
#       id (year) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Cast the melted data creating a data frame
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

dev.off()   #Close the PNG graphics device
