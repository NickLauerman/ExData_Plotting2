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

# Data setup
#   This is done in a seperate script "DataInput.R"
source("DataInput.R")

# Data selection and processing
#
# Extract the observation on Coal
#       Find SCC's were the EI.Sector contain the word coal or Coal
ListSCC <- SCC$SCC[grep("[Cc]oal", SCC$EI.Sector )]
#       Find which observation in pm25 have one of the above SCCs (meaning contain coal)
listCoal <- (pm25$SCC %in% ListSCC)
#       Select the needed obervatins
plot4raw <- pm25[listCoal,] 

# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the raw data
plot4Melt <- melt(plot4raw, id="year", measure.vars="Emissions")
#   The recast step takes the melted data and consolidates based on the specified
#       id (year) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Cast the melted data creating a data frame
plot4cast  <- dcast(plot4Melt, year ~ variable , sum)

# create the plot file
#   create a PNG device
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

dev.off() # close the PNG graphics device