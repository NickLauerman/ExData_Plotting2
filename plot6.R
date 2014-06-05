#
# plot 6
#
# Question to explore and conditions on exploration
#
# How have emissions from motor vehicle sources changed from 1990 to 2008
# in Balimore City, MD when compared to Los Angels County, CA?
#
# Restrictions, conditions and other key information
#       years 1999-2008
#       fibs    Baltimore   24510 
#               Los Angles  06037


# Setup
library(reshape2)
library(ggplot2)

# Read in data
pm25  <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# select observation from Baltimore City ... fips code 24510
plot6raw <- subset(pm25, (fips == "24510" | fips == "06037"))

# find motor vehicle sources.
#   choise to include all motor vehicles (including Planes, Marine Vessels,
#   On and Off road, light and heavy duty).
# EI.Section that starts with Mobile collects all SCC for this.
ListSCC <- SCC$SCC[grep("^Mobile", SCC$EI.Sector )]

# find which observation in pm25 have one of the above SCC codes
listVehicles <- (plot6raw$SCC %in% ListSCC)

# Select the identified observation
plot6raw <- plot6raw[listVehicles,]

# convert fips codes to names them make them the fips variable a factor
plot6raw$fips  <- sub("24510","Baltimore City", plot6raw$fips)
plot6raw$fips  <- sub("06037","Los Angeles County", plot6raw$fips)
plot6raw$fips <- as.factor(plot6raw$fips)

# Melt the data
plot6melt <- melt(plot6raw, id = c("year","fips"), measure.vars="Emissions")

# Recast the data
plot6cast <- dcast(plot6melt, year + fips ~ variable, sum)


#create a PNG
plotfile = "./figures/plot6a.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

plot6base <- ggplot(plot6cast, aes(year, Emissions))

plot6final <- plot6base +
    geom_point(color = "red") +
    geom_smooth(method = "lm", se = T) +
    theme_bw()+
    facet_grid(.~fips)

print(plot6final)

dev.off()


#create a PNG
plotfile = "./figures/plot6b.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

plot(plot6cast$year, plot6cast$Emissions,
     xlab = "year",
     ylab = "Emissions (tons)",
     type = "n")
points(subset(plot6cast, fips == "Baltimore City")$year,
       subset(plot6cast, fips == "Baltimore City")$Emissions,
       col = "red")
points(subset(plot6cast, fips == "Los Angeles County")$year,
       subset(plot6cast, fips == "Los Angeles County")$Emissions,
       col = "blue")
lines(subset(plot6cast, fips == "Baltimore City")$year,
      subset(plot6cast, fips == "Baltimore City")$Emissions,
      col = "red")
lines(subset(plot6cast, fips == "Los Angeles County")$year,
      subset(plot6cast, fips == "Los Angeles County")$Emissions,
      col = "blue")

LA <- subset(plot6cast, fips== "Los Angeles County")
modelLA <- lm(Emissions ~ year, LA)

abline(modelLA, 
       col = "blue",
       lty = 2)

Balt <- subset(plot6cast, fips== "Baltimore City")
modelBalt <- lm(Emissions ~ year, Balt)

abline(modelBalt, 
       col = "red",
       lty = 2)

legend("right",
       lty = c(1,2,1,2),
       pch = c(1,NA,1,NA),
       col = c("blue","blue","red","red"),
       legend = c("Los Angeles County",
                  "Los Angles trend",
                  "Baltimore",
                  "Baltimore trend"),
       bty = "n")
dev.off()


