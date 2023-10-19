setwd("/Users/renefehlmann/Documents/Privat/Jodok")

source("meineFarben.R")

gps_mobile <- read.table('gps_grdst.log',sep=",")

names(gps_mobile) <- c("Timestamp",
                       "SentenceID","Time","Latitude","N-S",
                       "Longitude","E-W","FixQ","NoSat","HDOP",
                       "Altitude","AltDim","HeightGeoid","HeightDim",
                       "TimeDGPSupdate","Checksum")

gps_mobile$Timestamp <- as.POSIXct(gps_mobile$Timestamp, format = "%m/%d/%Y %H:%M:%S")


gps_mobile$Altitude[gps_mobile$Altitude>750] <- NA
gps_mobile$Altitude[gps_mobile$Altitude<650] <-	NA

Alt <- gps_mobile$Altitude
AltRunMean <- Alt
runmean <- 91
nt <- length(AltRunMean)

for (i in ((runmean+1)/2):(nt-((runmean-1)/2))) {
  AltRunMean[i] <- mean(Alt[(i-(runmean-1)/2):(i+(runmean-1)/2)])
}

pdf(file = "AltitudeGrdStatRnMn.pdf",width=9, height=7)
plot(gps_mobile$Timestamp,
     AltRunMean,
     type = "l",cex=0.05,col="gray",xlab="Time",ylab="Alt mobile",
     ylim=c(600,800))
dev.off()
