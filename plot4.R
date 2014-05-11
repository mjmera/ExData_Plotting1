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

## plot 4

png(file = "plot4.png", width = 480, height = 480)

par(mfrow = c(2,2))


plot(plotData [,3], main = (""), type = "l", axes = FALSE,  
     xlab = "", ylab = "Global Active Power")
axis(1, at = c(0, 1440, 2880), lab = c("Thu", "Fri", "Sat"))
axis(2, at = seq(0,6,2))
box()


plot(plotData[,5], main = "", type = "l", axes = FALSE, 
     xlab = "datetime", ylab = "Voltage")
axis(1, at = c(0, 1440, 2880), lab = c("Thu", "Fri", "Sat"))
axis(2, at = seq(234,246,2))
box()


plot(plotData[,7], type = "l", col="black", axes = FALSE, xlab = "", ylab = "Energy sub metering") 
lines(plotData[,8], type = "l", col="red")
lines(plotData[,9], type = "l", col="blue")

legend("topright", lty = 1, col = c("black", "red", "blue"), bty ="n",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
axis(1, at = c(0, 1440, 2880), lab = c("Thu", "Fri", "Sat"))
axis(2, at = seq(0,30,10))  
box()


plot(plotData[,4], type ="l", axes = FALSE,
     xlab = "datetime", ylab = "Global_reactive_power",)
axis(1, at = c(0, 1440, 2880), lab = c("Thu", "Fri", "Sat"))
axis(2, at = seq(0,05,0.1))
box()

dev.off()
