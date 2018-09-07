## Coursera Exploratory Data Analysis - Course Project 1 ##
## title: plot2.R ##
## output: plot2.png ##
## author: Scott Robertson ##
## os: macOS 10.13.6 ##
## R version: 3.5.1 ##
## Required packages: dplyr, lubridate ##

## Pre-Processing: Install packages ##

if("dplyr" %in% rownames(installed.packages()) == FALSE){
      install.packages("dplyr")
}

if("lubridate" %in% rownames(installed.packages()) == FALSE){
      install.packages("lubridate")
}

library(dplyr)
library(lubridate)

## Step 1: Download Data ##

# Create "data" folder within working directory to store information if not
# already avaliable
if (!file.exists("data")) {
      dir.create("data")
}

# Set URL to download files from
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download files to data folder
download.file(fileUrl, "./data/dataset.zip", method = "curl")

# Store date of download in a value
dateDownloaded <- date()

# Extract files from zip. Will be stored as UCI HAR Dataset
unzip("./data/dataset.zip", exdir = "./data/")

# End of step message
message("Data downloaded and folders unzipped")


## Step 2: Reading raw data set into R and subsetting only required data ##

# Read in data set
power_con <- read.table("./data/household_power_consumption.txt", 
                        sep = ";", 
                        header = TRUE,
                        stringsAsFactors = FALSE,
                        dec = ".")

# Mutate Date column into date format
suppressWarnings(
      power_con <- mutate(power_con, 
                          Date = as.Date(Date, "%d/%m/%Y"),
                          Global_active_power = as.numeric(Global_active_power),
                          Global_reactive_power = as.numeric(Global_reactive_power),
                          Voltage = as.numeric(Voltage),
                          Global_intensity = as.numeric(Global_intensity),
                          Sub_metering_1 = as.numeric(Sub_metering_1),
                          Sub_metering_2 = as.numeric(Sub_metering_2),
                          Sub_metering_3 = as.numeric(Sub_metering_3)
      )
)

# Convet Time column into time format
strptime(as.character(power_con$Time), format = "%H:%M:%S")

# Filter out only data 2007-02-01 and 2007-02-02
power_con <- filter(power_con, Date == "2007-02-01" | Date == "2007-02-02")

# Create Datetime column for future graphing
power_con$Datetime <- ymd(power_con$Date) + hms(power_con$Time)
power_con$Date <- NULL
power_con$Time <- NULL

# End of step message
message("Date read in, formatted and filterd for graphing")


## Step 3: Create graph

# Initalize png file
png(filename = "plot2.png", width = 480, height = 480)

# Generate graph
plot(x = power_con$Datetime, 
     y = power_con$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

# Save graph to png file
dev.off()

# End of step message
message("Graph generated and saved to working directory as plot2.png")
