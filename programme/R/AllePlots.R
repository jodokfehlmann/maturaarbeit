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


nosatcolor <- 4
nosatmax <- 3
satmax <- max(gps_rover$NoSat,gps_grdst$NoSat)-nosatmax
satmin <- satmax-nosatcolor+1
colorlegend <- c(paste("<",as.character(satmin),sep=""),
                 as.character(c(satmin:satmax)),
                 paste(">",as.character(satmax),sep=""))
print("Max. Anzahl Sateliten")
print(satmax+nosatmax)


alleZeiten <- unique(sort(c(gps_grdst$Timestamp,gps_rover$Timestamp)))

AltRover <- rep(NA,length(alleZeiten))
AltGrdSt <- rep(NA,length(alleZeiten))
LonRover <- rep(NA,length(alleZeiten))
LonGrdSt <- rep(NA,length(alleZeiten))
LatRover <- rep(NA,length(alleZeiten))
LatGrdSt <- rep(NA,length(alleZeiten))
NoSatRover <- rep(NA,length(alleZeiten))
NoSatGrdSt <- rep(NA,length(alleZeiten))


for (i in 1:length(alleZeiten)){
  indRover <- which(gps_rover$Timestamp == alleZeiten[i])
  indGrdSt <- which(gps_grdst$Timestamp == alleZeiten[i])
  if (!identical(indRover, integer(0))){
    AltRover[i] <- gps_rover$Altitude[indRover]
    LonRover[i] <- gps_rover$Longitude[indRover]
    LatRover[i] <- gps_rover$Latitude[indRover]
    NoSatRover[i] <- gps_rover$NoSat[indRover]
  }
  if (!identical(indGrdSt, integer(0))){
    AltGrdSt[i] <- gps_grdst$Altitude[indGrdSt]
    LonGrdSt[i] <- gps_grdst$Longitude[indGrdSt]
    LatGrdSt[i] <- gps_grdst$Latitude[indGrdSt]
    NoSatGrdSt[i] <- gps_grdst$NoSat[indGrdSt]
  }
}


nrunmean <- 240
RunMeantmp <- rep(NA,length(alleZeiten))
for (i in (1+nrunmean):(length(alleZeiten)-nrunmean)){
  RunMeantmp[i] <- mean(AltRover[(i-nrunmean):(i+nrunmean)],na.rm = TRUE)
}
AltRover <- RunMeantmp
for (i in (1+nrunmean):(length(alleZeiten)-nrunmean)){
  RunMeantmp[i] <- mean(AltGrdSt[(i-nrunmean):(i+nrunmean)],na.rm = TRUE)
}
AltGrdSt <- RunMeantmp

for (i in (1+nrunmean):(length(alleZeiten)-nrunmean)){
  RunMeantmp[i] <- mean(LatRover[(i-nrunmean):(i+nrunmean)],na.rm = TRUE)
}
LatRover <- RunMeantmp
for (i in (1+nrunmean):(length(alleZeiten)-nrunmean)){
  RunMeantmp[i] <- mean(LatGrdSt[(i-nrunmean):(i+nrunmean)],na.rm = TRUE)
}
LatGrdSt <- RunMeantmp
  
gpsdata <- data.frame(alleZeiten,AltGrdSt,AltRover,LonGrdSt,LonRover,
                      LatGrdSt,LatRover,NoSatGrdSt,NoSatRover)

pdf(file = "Altitude.pdf",width=9, height=7)
altmin <- min(gpsdata$AltRover,na.rm = TRUE)
altmax <- max(gpsdata$AltRover,na.rm = TRUE)
plot(gpsdata$alleZeiten,
     gpsdata$AltRover,
     type = "p",cex=0.01,col="gray",xlab="Time (UTC)",ylab="Altitude",
     ylim=c(altmin,altmax))
points(gpsdata$alleZeiten[gpsdata$NoSatRover<satmin],
       gpsdata$AltRover[gpsdata$NoSatRover<satmin],
       pch=20,cex=0.15,col="black")
points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt<satmin],
       gpsdata$AltGrdSt[gpsdata$NoSatGrdSt<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$alleZeiten[gpsdata$NoSatRover>satmax],
       gpsdata$AltRover[gpsdata$NoSatRover>satmax],
       pch=20,cex=0.15,col="green")
points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt>satmax],
       gpsdata$AltGrdSt[gpsdata$NoSatGrdSt>satmax],
       pch=2,cex=0.15,col="green")
for (i in satmin:satmax){
  print(paste("Farbe:",toString(i)))
  points(gpsdata$alleZeiten[gpsdata$NoSatRover==i],
         gpsdata$AltRover[gpsdata$NoSatRover==i],
         pch=20,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
  points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt==i],
         gpsdata$AltGrdSt[gpsdata$NoSatGrdSt==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor),"green"), horiz=TRUE, cex=0.8)
dev.off()


pdf(file = "Latitude.pdf",width=9, height=7)
latmin <- min(gpsdata$LatRover,na.rm = TRUE)
latmax <- max(gpsdata$LatRover,na.rm = TRUE)
latmin <- 4711.25
latmax <- 4711.31
plot(gpsdata$alleZeiten,
     gpsdata$LatRover,
     type = "p",cex=0.01,col="gray",xlab="Time (UTC)",ylab="Latitude",
     ylim=c(latmin,latmax))
points(gpsdata$alleZeiten[gpsdata$NoSatRover<satmin],
       gpsdata$LatRover[gpsdata$NoSatRover<satmin],
       pch=20,cex=0.15,col="black")
points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt<satmin],
       gpsdata$LatGrdSt[gpsdata$NoSatGrdSt<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$alleZeiten[gpsdata$NoSatRover>satmax],
       gpsdata$LatRover[gpsdata$NoSatRover>satmax],
       pch=20,cex=0.15,col="green")
points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt>satmax],
       gpsdata$LatGrdSt[gpsdata$NoSatGrdSt>satmax],
       pch=2,cex=0.15,col="green")
for (i in satmin:satmax){
  print(paste("Farbe:",toString(i)))
  points(gpsdata$alleZeiten[gpsdata$NoSatRover==i],
         gpsdata$LatRover[gpsdata$NoSatRover==i],
         pch=20,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
  points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt==i],
         gpsdata$LatGrdSt[gpsdata$NoSatGrdSt==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor),"green"), horiz=TRUE, cex=0.8)
dev.off()


pdf(file = "Longitude.pdf",width=9, height=7)
lonmin <- min(gpsdata$LonRover,na.rm = TRUE)
lonmax <- max(gpsdata$LonRover,na.rm = TRUE)
lonmin <- 706.2
lonmax <- 706.3
plot(gpsdata$alleZeiten,
     gpsdata$LonRover,
     type = "p",cex=0.01,col="gray",xlab="Time (UTC)",ylab="Longitude",
     ylim=c(lonmin,lonmax))
points(gpsdata$alleZeiten[gpsdata$NoSatRover<satmin],
       gpsdata$LonRover[gpsdata$NoSatRover<satmin],
       pch=20,cex=0.15,col="black")
points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt<satmin],
       gpsdata$LonGrdSt[gpsdata$NoSatGrdSt<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$alleZeiten[gpsdata$NoSatRover>satmax],
       gpsdata$LonRover[gpsdata$NoSatRover>satmax],
       pch=20,cex=0.15,col="green")
points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt>satmax],
       gpsdata$LonGrdSt[gpsdata$NoSatGrdSt>satmax],
       pch=2,cex=0.15,col="green")
for (i in satmin:satmax){
  print(paste("Farbe:",toString(i)))
  points(gpsdata$alleZeiten[gpsdata$NoSatRover==i],
         gpsdata$LonRover[gpsdata$NoSatRover==i],
         pch=20,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
  points(gpsdata$alleZeiten[gpsdata$NoSatGrdSt==i],
         gpsdata$LonGrdSt[gpsdata$NoSatGrdSt==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor),"green"), horiz=TRUE, cex=0.8)
dev.off()



dat.clean<- na.omit(subset(gpsdata, select = c(alleZeiten,AltGrdSt,AltRover,LonGrdSt,LonRover,
                                               LatGrdSt,LatRover,NoSatGrdSt,NoSatRover)))

pdf(file = "ScatterAltiude.pdf",width=7, height=7)
plot(dat.clean$AltGrdSt,dat.clean$AltRover,
     type = "p",cex=0.01,col="gray",
     xlim=c(660,700),ylim=c(660,700),
     xlab="Groundstation",ylab="Rover")
points(gpsdata$AltGrdSt[gpsdata$NoSatGrdSt<satmin],
       gpsdata$AltRover[gpsdata$NoSatGrdSt<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$AltGrdSt[gpsdata$NoSatRover<satmin],
       gpsdata$AltRover[gpsdata$NoSatRover<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$AltGrdSt[gpsdata$NoSatGrdSt>satmax],
       gpsdata$AltRover[gpsdata$NoSatGrdSt>satmax],
       pch=2,cex=0.15,col="green")
points(gpsdata$AltGrdSt[gpsdata$NoSatRover>satmax],
       gpsdata$AltRover[gpsdata$NoSatRover>satmax],
       pch=2,cex=0.15,col="green")
for (i in satmin:satmax){
  points(gpsdata$AltGrdSt[gpsdata$NoSatGrdSt==i],
         gpsdata$AltRover[gpsdata$NoSatGrdSt==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
  points(gpsdata$AltGrdSt[gpsdata$NoSatRover==i],
         gpsdata$AltRover[gpsdata$NoSatRover==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor),"green"), horiz=TRUE, cex=0.8)
dev.off()

pdf(file = "ScatterLatitude.pdf",width=7, height=7)
plot(dat.clean$LatGrdSt,dat.clean$LatRover,
     type = "p",cex=0.01,col="gray",
     xlim=c(latmin,latmax),ylim=c(latmin,latmax),
     xlab="Groundstation",ylab="Rover")
points(gpsdata$LatGrdSt[gpsdata$NoSatGrdSt<satmin],
       gpsdata$LatRover[gpsdata$NoSatGrdSt<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$LatGrdSt[gpsdata$NoSatRover<satmin],
       gpsdata$LatRover[gpsdata$NoSatRover<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$LatGrdSt[gpsdata$NoSatGrdSt>satmax],
       gpsdata$LatRover[gpsdata$NoSatGrdSt>satmax],
       pch=2,cex=0.15,col="green")
points(gpsdata$LatGrdSt[gpsdata$NoSatRover>satmax],
       gpsdata$LatRover[gpsdata$NoSatRover>satmax],
       pch=2,cex=0.15,col="green")
for (i in satmin:satmax){
  points(gpsdata$LatGrdSt[gpsdata$NoSatGrdSt==i],
         gpsdata$LatRover[gpsdata$NoSatGrdSt==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
  points(gpsdata$LatGrdSt[gpsdata$NoSatRover==i],
         gpsdata$LatRover[gpsdata$NoSatRover==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor),"green"), horiz=TRUE, cex=0.8)
dev.off()


pdf(file = "ScatterLongitude.pdf",width=7, height=7)
plot(dat.clean$LonGrdSt,dat.clean$LonRover,
     type = "p",cex=0.01,col="gray",
     xlim=c(lonmin,lonmax),ylim=c(lonmin,lonmax),
     xlab="Groundstation",ylab="Rover")
points(gpsdata$LonGrdSt[gpsdata$NoSatGrdSt<satmin],
       gpsdata$LonRover[gpsdata$NoSatGrdSt<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$LonGrdSt[gpsdata$NoSatRover<satmin],
       gpsdata$LonRover[gpsdata$NoSatRover<satmin],
       pch=2,cex=0.15,col="black")
points(gpsdata$LonGrdSt[gpsdata$NoSatGrdSt>satmax],
       gpsdata$LonRover[gpsdata$NoSatGrdSt>satmax],
       pch=2,cex=0.15,col="green")
points(gpsdata$LonGrdSt[gpsdata$NoSatRover>satmax],
       gpsdata$LonRover[gpsdata$NoSatRover>satmax],
       pch=2,cex=0.15,col="green")
for (i in satmin:satmax){
  points(gpsdata$LonGrdSt[gpsdata$NoSatGrdSt==i],
         gpsdata$LonRover[gpsdata$NoSatGrdSt==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
  points(gpsdata$LonGrdSt[gpsdata$NoSatRover==i],
         gpsdata$LonRover[gpsdata$NoSatRover==i],
         pch=2,cex=0.15,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor),"green"), horiz=TRUE, cex=0.8)
dev.off()



pdf(file = "AltDiff.pdf",width=9, height=7)
plot(dat.clean$alleZeiten,
     (dat.clean$AltGrdSt-dat.clean$AltRover),
     type = "p",cex=0.05,col="red",xlab="Time",ylab="Altitude-Diff")
dev.off()

pdf(file = "LonDiff.pdf",width=9, height=7)
plot(dat.clean$alleZeiten,
     (dat.clean$LonGrdSt-dat.clean$LonRover),
     type = "p",cex=0.05,col="gray",xlab="Time",ylab="Longitude-Diff")
dev.off()

pdf(file = "LatDiff.pdf",width=9, height=7)
plot(dat.clean$alleZeiten,
     (dat.clean$LatGrdSt-dat.clean$LatRover),
     type = "p",cex=0.05,col="gray",xlab="Time",ylab="Latitude-Diff")
dev.off()