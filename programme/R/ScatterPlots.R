setwd("/Users/renefehlmann/Documents/Privat/Jodok")

source("meineFarben.R")

gps_rover <- read.table('TestGPS/gps_rover.log',sep=",",colClasses = "character")

names(gps_rover) <- c("Timestamp","millisec",
                      "SentenceID","Time","Latitude","N-S",
                      "Longitude","E-W","FixQ","NoSat","HDOP",
                      "Altitude","AltDim","HeightGeoid","HeightDim",
                      "TimeDGPSupdate","Checksum")

gps_rover$Timestamp <- paste(substr(gps_rover$Timestamp,1,11),
                             substr(gps_rover$Time,1,2),":",
                             substr(gps_rover$Time,3,4),":",
                             substr(gps_rover$Time,5,10),sep="")
gps_rover$Timestamp <- as.POSIXct(gps_rover$Timestamp,
                                  format = "%m/%d/%Y %H:%M:%OS")

gps_rover$Altitude <- as.numeric(gps_rover$Altitude)
gps_rover$Longitude <- as.numeric(gps_rover$Longitude)
gps_rover$Latitude <- as.numeric(gps_rover$Latitude)
gps_rover$NoSat <- as.numeric(gps_rover$NoSat)

gps_grdst <- read.table('TestGPS/gps_grdst.log',sep=",",colClasses = "character")

names(gps_grdst) <- c("Timestamp","millisec",
                      "SentenceID","Time","Latitude","N-S",
                      "Longitude","E-W","FixQ","NoSat","HDOP",
                      "Altitude","AltDim","HeightGeoid","HeightDim",
                      "TimeDGPSupdate","Checksum")

gps_grdst$Timestamp <- paste(substr(gps_grdst$Timestamp,1,11),
                             substr(gps_grdst$Time,1,2),":",
                             substr(gps_grdst$Time,3,4),":",
                             substr(gps_grdst$Time,5,10),sep="")
gps_grdst$Timestamp <- as.POSIXct(gps_grdst$Timestamp,
                                  format = "%m/%d/%Y %H:%M:%OS")

gps_grdst$Altitude <- as.numeric(gps_grdst$Altitude)
gps_grdst$Longitude <- as.numeric(gps_grdst$Longitude)
gps_grdst$Latitude <- as.numeric(gps_grdst$Latitude)
gps_grdst$NoSat <- as.numeric(gps_grdst$NoSat)

alleZeiten <- unique(sort(c(gps_grdst$Timestamp,gps_rover$Timestamp)))

AltRover <- rep(NA,length(alleZeiten))
AltGrdSt <- rep(NA,length(alleZeiten))

for (i in 1:length(alleZeiten)){
#  print(i)
  indRover <- which(gps_rover$Timestamp == alleZeiten[i])
  indGrdSt <- which(gps_grdst$Timestamp == alleZeiten[i])
  if (!identical(indRover, integer(0))){
    AltRover[i] <- gps_rover$Altitude[indRover]
  }
  if (!identical(indGrdSt, integer(0))){
    AltGrdSt[i] <- gps_grdst$Altitude[indGrdSt]
  }
}


altmingrdst <- min(AltGrdSt,na.rm = TRUE)
altmaxgrdst <- max(AltGrdSt,na.rm = TRUE)
altminrover <- min(AltRover,na.rm = TRUE)
altmaxrover <- max(AltRover,na.rm = TRUE)
altmin <- min(altmingrdst,altminrover)
altmax <- max(altmaxgrdst,altmaxrover)

dat <- data.frame(AltGrdSt,AltRover)
dat.clean<- na.omit(subset(dat, select = c(AltGrdSt, AltRover)))

pdf(file = "ScatterAltiude.pdf",width=7, height=7)
plot(dat.clean,
     type = "p",cex=0.2,col="gray",xlab="Groundstation",ylab="Rover",
     xlim=c(altmin,altmax),ylim=c(altmin,altmax))
dev.off()


LonRover <- rep(NA,length(alleZeiten))
LonGrdSt <- rep(NA,length(alleZeiten))

for (i in 1:length(alleZeiten)){
  #  print(i)
  indRover <- which(gps_rover$Timestamp == alleZeiten[i])
  indGrdSt <- which(gps_grdst$Timestamp == alleZeiten[i])
  if (!identical(indRover, integer(0))){
    LonRover[i] <- gps_rover$Longitude[indRover]
  }
  if (!identical(indGrdSt, integer(0))){
    LonGrdSt[i] <- gps_grdst$Longitude[indGrdSt]
  }
}


lonmingrdst <- min(LonGrdSt,na.rm = TRUE)
lonmaxgrdst <- max(LonGrdSt,na.rm = TRUE)
lonminrover <- min(LonRover,na.rm = TRUE)
lonmaxrover <- max(LonRover,na.rm = TRUE)
lonmin <- min(lonmingrdst,lonminrover)
lonmax <- max(lonmaxgrdst,lonmaxrover)

dat <- data.frame(LonGrdSt,LonRover)
dat.clean<- na.omit(subset(dat, select = c(LonGrdSt, LonRover)))

pdf(file = "ScatterLongitude.pdf",width=7, height=7)
plot(dat.clean,
     type = "p",cex=0.2,col="gray",xlab="Groundstation",ylab="Rover",
     xlim=c(lonmin,lonmax),ylim=c(lonmin,lonmax))
dev.off()



LatRover <- rep(NA,length(alleZeiten))
LatGrdSt <- rep(NA,length(alleZeiten))

for (i in 1:length(alleZeiten)){
  #  print(i)
  indRover <- which(gps_rover$Timestamp == alleZeiten[i])
  indGrdSt <- which(gps_grdst$Timestamp == alleZeiten[i])
  if (!identical(indRover, integer(0))){
    LatRover[i] <- gps_rover$Latitude[indRover]
  }
  if (!identical(indGrdSt, integer(0))){
    LatGrdSt[i] <- gps_grdst$Latitude[indGrdSt]
  }
}


latmingrdst <- min(LatGrdSt,na.rm = TRUE)
latmaxgrdst <- max(LatGrdSt,na.rm = TRUE)
latminrover <- min(LatRover,na.rm = TRUE)
latmaxrover <- max(LatRover,na.rm = TRUE)
latmin <- min(latmingrdst,latminrover)
latmax <- max(latmaxgrdst,latmaxrover)

dat <- data.frame(LatGrdSt,LatRover)
dat.clean<- na.omit(subset(dat, select = c(LatGrdSt, LatRover)))

pdf(file = "ScatterLatitude.pdf",width=7, height=7)
plot(dat.clean,
     type = "p",cex=0.2,col="gray",xlab="Groundstation",ylab="Rover",
     xlim=c(latmin,latmax),ylim=c(latmin,latmax))
dev.off()
