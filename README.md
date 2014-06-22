ExData_Plotting2
================

Project 2 for Exploratory Data Analysis

This class project is to explore EPA air pollution data set of
PM25 data. There are 6 specific questions that must be answered the a
single graph.

The data us in RDS file that are located in the data subdirectory.
THe filles are:

* `Source_Classification_Codes.rds`
* `summarySCC_PM25.rds`

Each of these when load into R produces a single data frame object.

The data directory also has a zip file (`exdata-data-NEI_data.zip`) that contains 
both of the above files which is the orginal supplied source.


Each question has it's own script.THe scripts are run using the `source()` 
command in R. They start assuming that the data has been uzipped in the data 
directory, but that the RDS file hasn't been loaded. THe operation of the script 
is documented via comments within the code.

At the high level the scripts input the one or both of the data frames, then 
select specific observation depending on the question that it is attempting to 
answer. The data is them "melted" and the "recast" using the `melt` and `dcast`
commands from the `reshape2` package.

script | question answered|plot file(s) produced
-------|-------------------|----
`plot1.R` | Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? | plot1.png
`plot2.R` | Have total emissions from PM2.5 decreased in the **Baltimore City**, Maryland (fips == "24510") from 1999 to 2008?|plot2.png
`plot3.R` | Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for **Baltimore City**? Which have seen increases in emissions from 1999–2008?|plot3.png
`plot4.R` | Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?|plot4.png
`plot5.R` | How have emissions from motor vehicle sources changed from 1999–2008 in **Baltimore City**?|plot5.png
`plot6.R` | Compare emissions from motor vehicle sources in **Baltimore City** with emissions from motor vehicle sources in **Los Angeles County**, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?|plot6a.png


Plots 1 and 2 are to be completed with **base** plotting in R.
Plot 3 is to be compted with the **ggplot2** package.



