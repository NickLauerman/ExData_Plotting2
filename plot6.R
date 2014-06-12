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


# Data setup
#   This is done in a seperate script "DataInput.R"
source("DataInput.R")

# Data selection and processing
#
# select observation from Baltimore City ... fips code 24510
#   and Los Angeles County, California  ... fips code 06037
plot6raw <- subset(pm25, (fips == "24510" | fips == "06037"))

# find vehicle sources.
#   choose to include all motor vehicles (including Planes, Marine Vessels,
#   On and Off road, light and heavy duty).
# EI.Section that starts with Mobile collects all SCC for this.
#   EI.Section has higher level groupings however these groupings include some
#   individual SCC that should not be included. Using the short names for the 
#   individual SCC will allow the exclusion for these SCC. The format of the a
#   hierarchical which will allow for excluding several SCC through a single term
#
# Using the Short.Name items that would have been included in the EI.Section 
#   collection are dealt with.
#
#   First tire and break wear are excluded,
#   then SCC for lawn and garden equipment (for example lawn mowers) are excluded,
#   then SCC for agricultural equipment (for example sprayers) are excluded,
#   then SCC for commercial equipment (for example generators) are excluded,
#   then SCC for chain saws and shedders used in logging are excluded,
#   finally SCC for equipment used in underground mining are are excluded.
ListSCC <- SCC$SCC[((grepl("^Mobile", SCC$EI.Sector))
                    & (!grepl("Wear$", SCC$Short.Name))
                    & (!grepl("Lawn & Garden", SCC$Short.Name))
                    & (!grepl("Agricultural Equipt", SCC$Short.Name))
                    & (!grepl("Commercial Equip", SCC$Short.Name))
                    & (!grepl("Logging Equipt /Chain Saws", SCC$Short.Name))
                    & (!grepl("Logging Equipt /Shredders", SCC$Short.Name))
                    & (!grepl("Underground Mining Equipt", SCC$Short.Name)))]

# find which observation in pm25 have one of the above SCC codes
listVehicles <- (plot6raw$SCC %in% ListSCC)

# Select the identified observation
plot6raw <- plot6raw[listVehicles,]

# convert fips codes to names them make them the fips variable a factor
#  the convertion from a numeric to a character will help in the final graph by
#  providing a human readable name to use in the plots.
plot6raw$fips  <- sub("24510","Baltimore City", plot6raw$fips)
plot6raw$fips  <- sub("06037","Los Angeles County", plot6raw$fips)
plot6raw$fips <- as.factor(plot6raw$fips)


# Using the reshape2 the selected data is processed into a usable form
#   The melt step selects specific elements from the data frame and creates a new
#       data frame that is properly formated (tall) for the next step in the process
#       recasting the data.
# Melt the data
plot6melt <- melt(plot6raw, id = c("year","fips"), measure.vars="Emissions")
#   The recaste step takes the melted data and consolidates based on the specified
#       id (year and fips) using the specified function (sum) on the melted
#       measurement variable (Emmissions)
# Recast the data creating a data frame
plot6cast <- dcast(plot6melt, year + fips ~ variable, sum)

# The plot file is produced
#   create a PNG device
plotfile = "./figures/plot6.png"
size = 500
png(filename = plotfile,
    width = size,
    height = size,
    units = "px")

# make the plot
#   set data for plot
plot6base <- ggplot(plot6cast, aes(year, Emissions))

#   make the plot object
plot6final <- plot6base +
    geom_point(color = "red") +
    geom_smooth(method = "glm", se = TRUE) +
    theme_bw()+
    facet_grid(.~fips) +
    ggtitle("Comparison of PM 2.5 Emission for Vehicles
            between Baltimore City & Los Angeles County") +
    ylab("PM 2.5 Emission (tons)")
    
print(plot6final)   #print the chart tot he graphics device

dev.off()           # close the PNG graphics device

