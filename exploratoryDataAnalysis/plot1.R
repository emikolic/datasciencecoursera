plot1<-function()
{
## in order to run this script you have to have a txt dataset in your working directory
##  reading txt file with data
data_full <- read.csv("household_power_consumption.txt", header=T, sep=';', na.strings="?", 
                      nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
data_full$Date <- as.Date(data_full$Date, format="%d/%m/%Y")

## getting only data for 2007.02.01 and 2007.02.02
data <- subset(data_full, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))

## convert dates
datetime <- paste(as.Date(data$Date), data$Time)
data$Datetime <- as.POSIXct(datetime)

## making a plot
hist(data$Global_active_power, main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

## save plot
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()
}