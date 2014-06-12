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

# Data setup
#   This is done in a seperate script "DataInput.R"
source("DataInput.R")


# Data selection and processing
#
# select data from fips 24510 (aka Baltimore)
plot2raw <- subset(pm25, fips == "24510")

# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the raw data
plot2Melt <- melt(plot2raw, id="year", measure.vars="Emissions")
#   The recast step takes the melted data and consolidates based on the specified
#       id (year) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Cast the melted data creating a data frame
plot2data <- dcast(plot2Melt, year ~ variable,sum)


# create the plot file
#   create a PNG device
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
dev.off()   #Close the PNG graphics device