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

gaga <- mean(gps_rover$Altitude,na.rm=TRUE)
print(gaga)
gps_rover$Altitude <- gps_rover$Altitude-gaga+694

gaga <- mean(gps_rover$Altitude,na.rm=TRUE)
print(gaga)

nosatcolor <- 5
satmax <- max(gps_rover$NoSat)
satmin <- satmax-nosatcolor+1
colorlegend <- c(paste("<",as.character(satmin),sep=""),
                 as.character(c(satmin:satmax)))

print("Max. Anzahl Sateliten")
print(satmax)

pdf(file = "AltitudeRover.pdf",width=9, height=7)
#png(file = "AltitudeRover.png", bg = "transparent", width = 724, height = 543)
altmin <- min(gps_rover$Altitude,na.rm = TRUE)
altmax <- max(gps_rover$Altitude,na.rm = TRUE)
#altmin <- 690
#altmax <- 698
plot(gps_rover$Timestamp,
     gps_rover$Altitude,
     type = "p",cex=0.05,col="gray",xlab="Time",ylab="Alt rover",
     ylim=c(altmin,altmax))
points(gps_rover$Timestamp[gps_rover$NoSat<satmin],
       gps_rover$Altitude[gps_rover$NoSat<satmin],
       pch=20,cex=0.1,col="black")
for (i in satmin:satmax){
  points(gps_rover$Timestamp[gps_rover$NoSat==i],
         gps_rover$Altitude[gps_rover$NoSat==i],
         pch=20,cex=0.1,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor)), horiz=TRUE, cex=0.8)
dev.off()

pdf(file = "LatitudeRover.pdf",width=9, height=7)
latmin <- min(gps_rover$Latitude,na.rm = TRUE)
latmax <- max(gps_rover$Latitude,na.rm = TRUE)
plot(gps_rover$Timestamp,
     gps_rover$Latitude,
     type = "l",cex=0.05,col="gray",xlab="Time",ylab="Lat rover",
     ylim=c(latmin,latmax))
points(gps_rover$Timestamp[gps_rover$NoSat<satmin],
       gps_rover$Latitude[gps_rover$NoSat<satmin],
       pch=20,cex=0.1,col="black")
for (i in satmin:satmax){
  points(gps_rover$Timestamp[gps_rover$NoSat==i],
         gps_rover$Latitude[gps_rover$NoSat==i],
         pch=20,cex=0.1,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor)), horiz=TRUE, cex=0.8)
dev.off()

pdf(file = "LongitudeRover.pdf",width=9, height=7)
lonmin <- min(gps_rover$Longitude,na.rm = TRUE)
lonmax <- max(gps_rover$Longitude,na.rm = TRUE)
plot(gps_rover$Timestamp,
     gps_rover$Longitude,
     type = "l",cex=0.05,col="gray",xlab="Time",ylab="Lon rover",
     ylim=c(lonmin,lonmax))
points(gps_rover$Timestamp[gps_rover$NoSat<satmin],
       gps_rover$Longitude[gps_rover$NoSat<satmin],
       pch=20,cex=0.1,col="black")
for (i in satmin:satmax){
  points(gps_rover$Timestamp[gps_rover$NoSat==i],
         gps_rover$Longitude[gps_rover$NoSat==i],
         pch=20,cex=0.1,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor)), horiz=TRUE, cex=0.8)
dev.off()
