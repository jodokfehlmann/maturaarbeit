setwd("/Users/renefehlmann/Documents/Privat/Jodok")

source("meineFarben.R")

gps_grdst  <- read.table('TestGPS/gps_grdst.log',sep=",")
gps_rover <- read.table('TestGPS/gps_rover.log',sep=",")

names(gps_grdst) <- c("Timestamp","millisec",
                       "SentenceID","Time","Latitude","N-S",
                       "Longitude","E-W","FixQ","NoSat","HDOP",
                       "Altitude","AltDim","HeightGeoid","HeightDim",
                       "TimeDGPSupdate","Checksum")

names(gps_rover) <- c("Timestamp","millisec",
                       "SentenceID","Time","Latitude","N-S",
                       "Longitude","E-W","FixQ","NoSat","HDOP",
                       "Altitude","AltDim","HeightGeoid","HeightDim",
                       "TimeDGPSupdate","Checksum")


gps_grdst$Timestamp  <- as.POSIXct(gps_grdst$Timestamp, format = "%m/%d/%Y %H:%M:%S")
gps_rover$Timestamp <- as.POSIXct(gps_rover$Timestamp, format = "%m/%d/%Y %H:%M:%S")


# Zeiten vergleichen:

pdf(file = "Zeiten.pdf",width=7, height=7)
plot(gps_grdst$Timestamp,
     gps_rover$Timestamp,
     type = "l",cex=0.05,col="gray",xlab="Time Grd-Station",ylab="Time Rover")
points(gps_grdst$Timestamp,
       gps_rover$Timestamp,
       pch=20,cex=0.1,col="black")
dev.off()


GPS_Diff <- data.frame(gps_grdst$Timestamp,
                       gps_grdst$NoSat,
#                                  min(gps_rover$NoSat,gps_grdst$NoSat),
                       gps_rover$Latitude-gps_grdst$Latitude,
                       gps_rover$Longitude-gps_grdst$Longitude,
                       gps_rover$Altitude-gps_grdst$Altitude)

names(GPS_Diff) <- c("Timestamp","MinNoSat","LatDiff","LongDiff","AltDiff")

pdf(file = "AltitudeDiff.pdf",width=9, height=7)
plot(GPS_Diff$Timestamp,
     GPS_Diff$AltDiff,
#     pch=20,cex=1,col="white",
     type = "l",cex=0.05,col="gray",
     xlab="Time",ylab="Alt diff",ylim=c(-1,5))
points(GPS_Diff$Timestamp[GPS_Diff$MinNoSat<4],
       GPS_Diff$AltDiff[GPS_Diff$MinNoSat<4],
       pch=20,cex=0.3,col="black")
for (i in 4:8){
  points(GPS_Diff$Timestamp[GPS_Diff$MinNoSat==i],
         GPS_Diff$AltDiff[GPS_Diff$MinNoSat==i],
         pch=20,cex=0.3,col=meineFarben(5)[i-3])
}
legend("bottomleft", inset=.02, title="number of satellites",
       c("<4","4","5","6","7","8"), fill=c("black",
                                   meineFarben(5)[1],
                                   meineFarben(5)[2],
                                   meineFarben(5)[3],
                                   meineFarben(5)[4],
                                   meineFarben(5)[5]), horiz=TRUE, cex=0.8)
dev.off()


pdf(file = "LatitudeDiff.pdf",width=9, height=7)
plot(GPS_Diff$Timestamp,
     GPS_Diff$LatDiff,
#     pch=20,cex=1,col="white",
     type = "l",cex=0.05,col="gray",
     xlab="Time",ylab="Lat diff",
     ylim=c(-0.005,0.005))
points(GPS_Diff$Timestamp[GPS_Diff$MinNoSat<4],
       GPS_Diff$LatDiff[GPS_Diff$MinNoSat<4],
       pch=20,cex=0.3,col="black")
for (i in 4:8){
  points(GPS_Diff$Timestamp[GPS_Diff$MinNoSat==i],
         GPS_Diff$LatDiff[GPS_Diff$MinNoSat==i],
         pch=20,cex=0.3,col=meineFarben(5)[i-3])
}
legend("bottomleft", inset=.02, title="number of satellites",
       c("<4","4","5","6","7","8"), fill=c("black",
                                   meineFarben(5)[1],
                                   meineFarben(5)[2],
                                   meineFarben(5)[3],
                                   meineFarben(5)[4],
                                   meineFarben(5)[5]), horiz=TRUE, cex=0.8)
dev.off()


pdf(file = "LongitudeDiff.pdf",width=9, height=7)
plot(GPS_Diff$Timestamp,
     GPS_Diff$LongDiff,
#     pch=20,cex=1,col="white",
     type = "l",cex=0.05,col="gray",
     xlab="Time",ylab="Lon diff",
     ylim=c(-0.005,0.005))
points(GPS_Diff$Timestamp[GPS_Diff$MinNoSat<4],
       GPS_Diff$LongDiff[GPS_Diff$MinNoSat<4],
       pch=20,cex=0.3,col="black")
for (i in 4:8){
  points(GPS_Diff$Timestamp[GPS_Diff$MinNoSat==i],
         GPS_Diff$LongDiff[GPS_Diff$MinNoSat==i],
         pch=20,cex=0.3,col=meineFarben(5)[i-3])
}
legend("bottomleft", inset=.02, title="number of satellites",
       c("<4","4","5","6","7","8"), fill=c("black",
                                   meineFarben(5)[1],
                                   meineFarben(5)[2],
                                   meineFarben(5)[3],
                                   meineFarben(5)[4],
                                   meineFarben(5)[5]), horiz=TRUE, cex=0.8)
dev.off()
