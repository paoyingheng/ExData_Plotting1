power <- read.table("~/power/household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", nrows=69516, colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

#selecting only rows pertaining to Feb 1st 2007 to Feb 2nd 2007
power1 <- power[66637:69516,]


#Format date using as.Date
power1$Date <- as.Date(power1$Date, "%d/%m/%Y")

#Selecting rows which are complete
power1 <- power1[complete.cases(power1),]

#Combining date and time columns
datetime <- paste(power1$Date, power1$Time)

#Naming the combined column
datetime <- setNames(datetime, "DateTime")

#Removing the original Date and Time columns from the power1 dataset
power1 <- power1[ ,!(names(power1) %in% c("Date","Time"))]

#Adding the new column (datetime) into the power1 dataset
power1 <- cbind(datetime, power1)

#Formatting the datetime column in the updated power1 dataset
power1$datetime <- as.POSIXct(datetime)

##plot 3
png("plot3.png", width = 480, height = 480)
with(power1, {
  plot(datetime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab=" ")
  lines(datetime, Sub_metering_2, col="red")
  lines(datetime, Sub_metering_3, col="blue")
  legend("topright", lty = 1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()