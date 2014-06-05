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

# Read in data


pm25  <- readRDS("./data/summarySCC_PM25.rds")

# select data from fips 24510 (aka Baltimore)

plot3raw <- subset(pm25, fips == "24510")

# melt the raw data
plot3melt  <- melt(plot3raw, id=c("year","type") , measure.vars="Emissions")

# recast the melted data
plot3cast <- dcast(plot3melt, year + type ~ variable, sum)

# make the plot

# set data for plot
plot3base  <-  ggplot(plot3cast, aes(year,Emissions))

#make the plot object
plot3final<- plot3base  + 
    geom_point(color = "red") + 
    facet_grid(. ~ type) + 
    geom_smooth(method = "lm", se = FALSE) + 
    theme_bw()


#create a PNG
plotfile = "./figures/plot3.png"

png(filename = plotfile,
    width = 1500,
    height = 500,
    units = "px")


plot3final

dev.off()
