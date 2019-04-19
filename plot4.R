#Downloads file from target URL
data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(data_url, "power.zip")

#Unzips downloaded file into folder called 'power'
unzip("power.zip", exdir="power")

#Reads the txt file, while addressing missing values, limiting the rows read to the last row with Feb 2nd 2007 data, 
#as well as specifying column classes
power <- read.table("~/power/household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", nrows=69516, colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

#select only rows pertaining to Feb 1st 2007 to Feb 2nd 2007
power1 <- power[66637:69516,]

#Format date using as.Date
power1$Date <- as.Date(power1$Date, "%d/%m/%Y")

#Select only rows which are complete
power1 <- power1[complete.cases(power1),]

#Combine the Date and Time columns
datetime <- paste(power1$Date, power1$Time)

#Name the combined column
datetime <- setNames(datetime, "DateTime")

#Remove the original Date and Time columns from the power1 dataset
power1 <- power1[ ,!(names(power1) %in% c("Date","Time"))]

#Add the new column (datetime) into the power1 dataset
power1 <- cbind(datetime, power1)

#Format the datetime column in the updated power1 dataset
power1$datetime <- as.POSIXct(datetime)


##Plot and save Plot 4
png("plot4.png", width = 480, height = 480)

par(mfrow=c(2,2))
with(power1, {
  plot(power1$Global_active_power~power1$datetime, type="l", ylab="Global Active Power", xlab=" ")
  plot(power1$Voltage~power1$datetime, type="l", ylab="Voltage", xlab="datetime")
  with(power1, {
    plot(datetime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab=" ")
    lines(datetime, Sub_metering_2, col="red")
    lines(datetime, Sub_metering_3, col="blue")
    legend("topright", lty = 1, col=c("black", "red", "blue"), bty = "n", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  })
  plot(power1$Global_reactive_power~power1$datetime, type="l", ylab="Global_reactive_power", xlab="datetime")
})
dev.off()
