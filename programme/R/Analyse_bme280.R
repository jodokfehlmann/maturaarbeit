setwd("/Users/renefehlmann/Documents/Privat/Jodok")

source("meineFarben.R")

atm_bme280 <- read.table('gps_bme280.log',sep=",")

names(atm_bme280) <- c("Timestamp","P","RH","T",
                       "SentenceID","Time","Latitude","N-S",
                       "Longitude","E-W","FixQ","NoSat","HDOP",
                       "Altitude","AltDim","HeightGeoid","HeightDim",
                       "TimeDGPSupdate","Checksum")

atm_bme280$Timestamp <- as.POSIXct(atm_bme280$Timestamp, format = "%m/%d/%Y %H:%M:%S")

pdf(file = "Altitude.pdf",width=9, height=7)
plot(atm_bme280$Timestamp[atm_bme280$NoSat<8],
     atm_bme280$Altitude[atm_bme280$NoSat<8],
     pch=20,cex=1,col="white",xlab="Time",ylab="Altitude")
points(atm_bme280$Timestamp[atm_bme280$NoSat<4],
       atm_bme280$Altitude[atm_bme280$NoSat<4],
       pch=20,cex=0.5,col="black")
for (i in 4:8){
  points(atm_bme280$Timestamp[atm_bme280$NoSat==i],
         atm_bme280$Altitude[atm_bme280$NoSat==i],
         pch=20,cex=0.5,col=meineFarben(5)[i-3])
}
legend("bottomleft", inset=.02, title="number of satellites",
       c("<4","4","5","6","7","8"), fill=c("black",
                                   meineFarben(5)[1],
                                   meineFarben(5)[2],
                                   meineFarben(5)[3],
                                   meineFarben(5)[4],
                                   meineFarben(5)[5]), horiz=TRUE, cex=0.8)
dev.off()


pdf(file = "Latitude.pdf",width=9, height=7)
plot(atm_bme280$Timestamp[atm_bme280$NoSat<8],
     atm_bme280$Latitude[atm_bme280$NoSat<8],
     pch=20,cex=1,col="white",xlab="Time",ylab="Latitude")
points(atm_bme280$Timestamp[atm_bme280$NoSat<4],
       atm_bme280$Latitude[atm_bme280$NoSat<4],
       pch=20,cex=0.5,col="black")
for (i in 4:8){
  points(atm_bme280$Timestamp[atm_bme280$NoSat==i],
         atm_bme280$Latitude[atm_bme280$NoSat==i],
         pch=20,cex=0.5,col=meineFarben(5)[i-3])
}
legend("bottomleft", inset=.02, title="number of satellites",
       c("<4","4","5","6","7","8"), fill=c("black",
                                   meineFarben(5)[1],
                                   meineFarben(5)[2],
                                   meineFarben(5)[3],
                                   meineFarben(5)[4],
                                   meineFarben(5)[5]), horiz=TRUE, cex=0.8)
dev.off()


pdf(file = "Longitude.pdf",width=9, height=7)
plot(atm_bme280$Timestamp[atm_bme280$NoSat<8],
     atm_bme280$Longitude[atm_bme280$NoSat<8],
     pch=20,cex=1,col="white",xlab="Time",ylab="Longitude")
points(atm_bme280$Timestamp[atm_bme280$NoSat<4],
       atm_bme280$Longitude[atm_bme280$NoSat<4],
       pch=20,cex=0.5,col="black")
for (i in 4:8){
  points(atm_bme280$Timestamp[atm_bme280$NoSat==i],
         atm_bme280$Longitude[atm_bme280$NoSat==i],
         pch=20,cex=0.5,col=meineFarben(5)[i-3])
}
legend("bottomleft", inset=.02, title="number of satellites",
       c("<4","4","5","6","7","8"), fill=c("black",
                                   meineFarben(5)[1],
                                   meineFarben(5)[2],
                                   meineFarben(5)[3],
                                   meineFarben(5)[4],
                                   meineFarben(5)[5]), horiz=TRUE, cex=0.8)
dev.off()



pdf(file = "Pressure.pdf")
plot(atm_bme280$Timestamp,atm_bme280$P,type="l",
     xlab="Time",ylab="Pressure")
dev.off()

pdf(file = "RelHumidity.pdf")
plot(atm_bme280$Timestamp,atm_bme280$RH,type="l",
     xlab="Time",ylab="rel. humidity")
dev.off()

pdf(file = "Temperature.pdf")
plot(atm_bme280$Timestamp,atm_bme280$T,type="l",
     xlab="Time",ylab="Temperature")
dev.off()

pdf(file = "Scatterplot.pdf")
plot(atm_bme280$P,atm_bme280$Altitude,
     ylab="Altitude",xlab="Pressure",col="white")
points(atm_bme280$P[atm_bme280$NoSat<4],
       atm_bme280$Altitude[atm_bme280$NoSat<4],
       pch=20,cex=0.5,col="black")
for (i in 4:8){
  points(atm_bme280$P[atm_bme280$NoSat==i],
         atm_bme280$Altitude[atm_bme280$NoSat==i],
         pch=20,cex=0.5,col=meineFarben(5)[i-3])
}
legend("bottomleft", inset=.02, title="number of satellites",
       c("<4","4","5","6","7","8"), fill=c("black",
                                           meineFarben(5)[1],
                                           meineFarben(5)[2],
                                           meineFarben(5)[3],
                                           meineFarben(5)[4],
                                           meineFarben(5)[5]), horiz=TRUE, cex=0.8)
dev.off()

