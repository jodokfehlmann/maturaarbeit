setwd("/Users/renefehlmann/Documents/Privat/Jodok")

source("meineFarben.R")

press_rover <- read.table('TestPress/press_rover.log',sep=",",colClasses = "character")
names(press_rover) <- c("Timestamp","Pressure")
press_rover$Timestamp <- as.POSIXct(press_rover$Timestamp,
                                  format = "%m/%d/%Y %H:%M:%S")
press_rover$Pressure <- as.numeric(press_rover$Pressure)

press_grdst <- read.table('TestPress/press_grdst.log',sep=",",colClasses = "character")
names(press_grdst) <- c("Timestamp","Pressure")
press_grdst$Timestamp <- as.POSIXct(press_grdst$Timestamp,
                                  format = "%m/%d/%Y %H:%M:%S")

press_grdst$Pressure <- as.numeric(press_grdst$Pressure)

pressrovermean <- mean(press_rover$Pressure)
pressgrdstmean <- mean(press_grdst$Pressure)
prdiff <- pressgrdstmean-pressrovermean

pressrover <- press_rover$Pressure
pressgrdst <- press_grdst$Pressure

pressrover <- pressrover+prdiff

pdf(file = "PressureTest.pdf",width=8, height=8)
plot(pressgrdst,
     pressrover,
     type = "p",cex=0.25,col="gray",xlab="Groundstation",ylab="Rover")
dev.off()
