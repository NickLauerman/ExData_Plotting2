#
# plot 3
#
# Question to explore and conditions on exploration
#
# Which emission types have increase and decreased in Baltimore
# during the perios of 1999-2008
#
# Restrictions, conditions and other key information
#       use ggplot2 package
#       years 1999-2008
#       fips is 24510

# Setup
library(reshape2)
library(ggplot2)

# Data setup
#   This is done in a seperate script "DataInput.R"
source("DataInput.R")

# Data selection and processing
#
# select data from fips 24510 (aka Baltimore)
plot3raw <- subset(pm25, fips == "24510")

# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the raw data
plot3melt  <- melt(plot3raw, id=c("year","type") , measure.vars="Emissions")
#   The recast step takes the melted data and consolidates based on the specified
#       id (year and type) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Cast the melted data creating a data frame
plot3cast <- dcast(plot3melt, year + type ~ variable, sum)

# make the plot

#   set data for plot
plot3base  <-  ggplot(plot3cast, aes(year,Emissions))

#   make the plot object
plot3final<- plot3base  + 
    geom_point(color = "red") + 
    facet_grid(. ~ type) + 
    geom_smooth(method = "lm", se = FALSE) + 
    theme_bw() +
    ggtitle("Tends of PM 2.5 Emission by Emmision Type
            for Baltimore City") +
    ylab("PM 2.5 Emission (tons)")

#create a PNG device
plotfile = "./figures/plot3.png"
png(filename = plotfile,
    width = 2000,
    height = 500,
    units = "px")

print(plot3final)   #print the plot

dev.off()           #close the PNG graphics device