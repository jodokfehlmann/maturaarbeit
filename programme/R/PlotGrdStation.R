setwd("/Users/renefehlmann/Documents/Privat/Jodok")

source("meineFarben.R")

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

gaga <- mean(gps_grdst$Altitude,na.rm=TRUE)
print(gaga)
gps_grdst$Altitude <- gps_grdst$Altitude-gaga+694

gaga <- mean(gps_grdst$Altitude,na.rm=TRUE)
print(gaga)

nosatcolor <- 5
satmax <- max(gps_grdst$NoSat)
satmin <- satmax-nosatcolor+1
colorlegend <- c(paste("<",as.character(satmin),sep=""),
                 as.character(c(satmin:satmax)))

print("Max. Anzahl Sateliten")
print(satmax)

pdf(file = "AltitudeGrdst.pdf",width=9, height=7)
#png(file = "AltitudeGrdst.png", bg = "transparent", width = 724, height = 543)
altmin <- min(gps_grdst$Altitude,na.rm = TRUE)
altmax <- max(gps_grdst$Altitude,na.rm = TRUE)
#altmin <- 690
#altmax <- 698
plot(gps_grdst$Timestamp,
     gps_grdst$Altitude,
     type = "p",cex=0.05,col="gray",xlab="Time",ylab="Alt grd-station",
     ylim=c(altmin,altmax))
points(gps_grdst$Timestamp[gps_grdst$NoSat<satmin],
       gps_grdst$Altitude[gps_grdst$NoSat<satmin],
       pch=20,cex=0.1,col="black")
for (i in satmin:satmax){
  points(gps_grdst$Timestamp[gps_grdst$NoSat==i],
         gps_grdst$Altitude[gps_grdst$NoSat==i],
         pch=20,cex=0.1,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor)), horiz=TRUE, cex=0.8)
dev.off()

pdf(file = "LatitudeGrdst.pdf",width=9, height=7)
latmin <- min(gps_grdst$Latitude,na.rm = TRUE)
latmax <- max(gps_grdst$Latitude,na.rm = TRUE)
plot(gps_grdst$Timestamp,
     gps_grdst$Latitude,
     type = "l",cex=0.05,col="gray",xlab="Time",ylab="Lat grd-station",
     ylim=c(latmin,latmax))
points(gps_grdst$Timestamp[gps_grdst$NoSat<satmin],
       gps_grdst$Latitude[gps_grdst$NoSat<satmin],
       pch=20,cex=0.1,col="black")
for (i in satmin:satmax){
  points(gps_grdst$Timestamp[gps_grdst$NoSat==i],
         gps_grdst$Latitude[gps_grdst$NoSat==i],
         pch=20,cex=0.1,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor)), horiz=TRUE, cex=0.8)
dev.off()

pdf(file = "LongitudeGrdst.pdf",width=9, height=7)
lonmin <- min(gps_grdst$Longitude,na.rm = TRUE)
lonmax <- max(gps_grdst$Longitude,na.rm = TRUE)
plot(gps_grdst$Timestamp,
     gps_grdst$Longitude,
     type = "l",cex=0.05,col="gray",xlab="Time",ylab="Lon grd-station",
     ylim=c(lonmin,lonmax))
points(gps_grdst$Timestamp[gps_grdst$NoSat<satmin],
       gps_grdst$Longitude[gps_grdst$NoSat<satmin],
       pch=20,cex=0.1,col="black")
for (i in satmin:satmax){
  points(gps_grdst$Timestamp[gps_grdst$NoSat==i],
         gps_grdst$Longitude[gps_grdst$NoSat==i],
         pch=20,cex=0.1,col=meineFarben(nosatcolor)[i+1-satmin])
}
legend("bottomleft", inset=.02, title="number of satellites",
       colorlegend, fill=c("black",meineFarben(nosatcolor)), horiz=TRUE, cex=0.8)
dev.off()
