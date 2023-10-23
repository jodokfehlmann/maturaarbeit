setwd("/Users/renefehlmann/Documents/Privat/Jodok")

source("meineFarben.R")

press_rover <- read.table('TestGPS/pressGPS_rover.log',sep=",",colClasses = "character")
names(press_rover) <- c("Timestamp","Temp","Alt","Pressure",
                        "SentenceID","Time","Latitude","N-S",
                        "Longitude","E-W","FixQ","NoSat","HDOP",
                        "Altitude","AltDim","HeightGeoid","HeightDim",
                        "TimeDGPSupdate","Checksum")
press_rover$Timestamp <- as.POSIXct(press_rover$Timestamp,
                                  format = "%m/%d/%Y %H:%M:%S")
press_rover$Temp <- as.numeric(press_rover$Temp)
press_rover$Alt <- as.numeric(press_rover$Alt)
press_rover$Pressure <- as.numeric(press_rover$Pressure)
press_rover$Latitude <- as.numeric(press_rover$Latitude)
press_rover$Longitude <- as.numeric(press_rover$Longitude)
press_rover$Altitude <- as.numeric(press_rover$Altitude)

press_grdst <- read.table('TestGPS/pressGPS_grdst.log',sep=",",colClasses = "character")
names(press_grdst) <- c("Timestamp","Temp","Alt","Pressure",
                        "SentenceID","Time","Latitude","N-S",
                        "Longitude","E-W","FixQ","NoSat","HDOP",
                        "Altitude","AltDim","HeightGeoid","HeightDim",
                        "TimeDGPSupdate","Checksum")
press_grdst$Timestamp <- as.POSIXct(press_grdst$Timestamp,
                                  format = "%m/%d/%Y %H:%M:%S")


press_grdst$Temp <- as.numeric(press_grdst$Temp)
press_grdst$Alt <- as.numeric(press_grdst$Alt)
press_grdst$Pressure <- as.numeric(press_grdst$Pressure)
press_grdst$Latitude <- as.numeric(press_grdst$Latitude)
press_grdst$Longitude <- as.numeric(press_grdst$Longitude)
press_grdst$Altitude <- as.numeric(press_grdst$Altitude)


alleZeiten <- unique(sort(c(press_grdst$Timestamp,press_rover$Timestamp)))


TempRover <- rep(NA,length(alleZeiten))
TempGrdSt <- rep(NA,length(alleZeiten))
AltRover <- rep(NA,length(alleZeiten))
AltGrdSt <- rep(NA,length(alleZeiten))
PressureRover <- rep(NA,length(alleZeiten))
PressureGrdSt <- rep(NA,length(alleZeiten))
AltitudeRover <- rep(NA,length(alleZeiten))
AltitudeGrdSt <- rep(NA,length(alleZeiten))
LonRover <- rep(NA,length(alleZeiten))
LonGrdSt <- rep(NA,length(alleZeiten))
LatRover <- rep(NA,length(alleZeiten))
LatGrdSt <- rep(NA,length(alleZeiten))
NoSatRover <- rep(NA,length(alleZeiten))
NoSatGrdSt <- rep(NA,length(alleZeiten))


for (i in 1:length(alleZeiten)){
  indRover <- which(press_rover$Timestamp == alleZeiten[i])
  indGrdSt <- which(press_grdst$Timestamp == alleZeiten[i])
  if (!identical(indRover, integer(0))){
    TempRover[i] <- press_rover$Temp[indRover]
    AltRover[i] <- press_rover$Alt[indRover]
    PressureRover[i] <- press_rover$Pressure[indRover]
    AltitudeRover[i] <- press_rover$Altitude[indRover]
    LonRover[i] <- press_rover$Longitude[indRover]
    LatRover[i] <- press_rover$Latitude[indRover]
    NoSatRover[i] <- press_rover$NoSat[indRover]
  }
  if (!identical(indGrdSt, integer(0))){
    TempGrdSt[i] <- press_grdst$Temp[indGrdSt]
    AltGrdSt[i] <- press_grdst$Alt[indGrdSt]
    PressureGrdSt[i] <- press_grdst$Pressure[indGrdSt]
    AltitudeGrdSt[i] <- press_grdst$Altitude[indGrdSt]
    LonGrdSt[i] <- press_grdst$Longitude[indGrdSt]
    LatGrdSt[i] <- press_grdst$Latitude[indGrdSt]
    NoSatGrdSt[i] <- press_grdst$NoSat[indGrdSt]
  }
}


pressrovermean <- mean(PressureRover,na.rm = TRUE)
pressgrdstmean <- mean(PressureGrdSt,na.rm = TRUE)
prdiff <- pressgrdstmean-pressrovermean


altrovermean <- mean(AltRover,na.rm = TRUE)
altgrdstmean <- mean(AltGrdSt,na.rm = TRUE)
altdiff <- altgrdstmean-altrovermean

AltRover <- AltRover+altdiff

pdf(file = "PressureTest.pdf",width=8, height=8)
plot(PressureGrdSt,
     PressureRover,
     type = "p",cex=0.15,col="blue",xlab="Groundstation",ylab="Rover")
dev.off()


pdf(file = "AltTest.pdf",width=8, height=8)
plot(AltGrdSt,
     AltRover,
     type = "p",cex=0.15,col="blue",xlab="Groundstation",ylab="Rover")
dev.off()



altdiff = AltRover-AltGrdSt+668.
pdf(file = "Altkorr.pdf",width=8, height=8)
plot(alleZeiten,
     altdiff,
     type = "l",cex=0.15,col="blue",xlab="Time",ylab="Altitude")
dev.off()

