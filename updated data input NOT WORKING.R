# PM25 <- readRDS("data/summarySCC_PM25.rds")

zip = "./data/exdata-data-NEI_data.zip"
file1 = "Source_Classification_Code.rds"
file2 = "summarySCC_PM25.rds"
con <- unz(zip,file1, open = "rb")
hold <- readRDS(file = con)
close(con)

