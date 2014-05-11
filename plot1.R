# check if the file already exists and create one if it doesn't
zipName <- "Power_Data/exdata-data-household_power_consumption.zip"
fileName <- "Power_Data/household_power_consumption.txt"

if (!file.exists("Power_Data")){
    dir.create("Power_Data")
    
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl,destfile = zipName) #download file
    
    unzip(zipName, exdir="Power_Data") #unzip to the file 
}

# Read the data from the two days. Find the first day and skip to it
# Read th entries for both days = one entry per minute, 60 entries per hour, for 48 hours
# the number of rows to be read = (60*48)

# change date format
setClass("mydate")
setAs("character","mydate", function(from) as.Date(from, format="%d/%m/%Y") ) 

# make a table of only the dates to read
tableDates <- read.table(fileName, header = TRUE, sep = ";", as.is = TRUE, 
                       colClasses = c("mydate", rep("NULL", 8)))

findDates <- (tableDates[,1] == as.Date("01/02/2007", "%d/%m/%Y"))
skipRows <- which.max(findDates)-1 # find the index of the first occurance (true)

plotData <- read.table(fileName, header = TRUE, sep = ";", as.is = TRUE, na.strings = "?" , 
                       skip = skipRows, nrows = 48*60 )

## plot

png(file = "plot1.png", width = 480, height = 480, bg="transparent")

hist(plotData[,3], 
     main = "Global Active Power", xlab = "Global Active Power (Kilowatts)", col = "red")
dev.off()
