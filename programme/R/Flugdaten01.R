library(gplots)
library(ncdf4)

source("ch1903wgs84.R")

rover <- read.table('../log/rover.log',sep=",",colClasses = "character")
names(rover) <- c("Timestamp","Tmilli","distLidar",
                        "SentenceID","TimeGPS","Latitude","N_S",
                        "Longitude","E_W","FixQ","NoSat","HDOP",
                        "Altitude","AltDim","HeightGeoid","HeightDim",
                        "TimeDGPSupdate","Checksum")
rover$Timestamp <- strptime(paste(rover$Timestamp,
                                  ".",rover$Tmilli,sep=""),
                                  "%m/%d/%Y %H:%M:%OS")
rover$Latitude <- as.numeric(rover$Latitude)
rover$Longitude <- as.numeric(rover$Longitude)
rover$Altitude <- as.numeric(rover$Altitude)
rover$distLidar <- as.numeric(rover$distLidar)

xbahn <- rover$Longitude/100.
ybahn <- rover$Latitude/100.
zbahn <- rover$Altitude-rover$distLidar/100.
zerr <- rep(NA,length(zbahn))

for (i in 1:length(xbahn)) {
  xbahn[i]<-minutes2decimal(xbahn[i])
  ybahn[i]<-minutes2decimal(ybahn[i])
  resxyz <- Grad_to_LV95(xbahn[i],ybahn[i],zbahn[i])
  xbahn[i]<-resxyz[1]/1000.
  ybahn[i]<-resxyz[2]/1000.
  zbahn[i]<-resxyz[3]
}

# Aufloesung (Entweder 2 oder 0.5 m)
#res <- "2"
res <- "0.5"

fileIn <- paste("SWISS_ALTI3D_",res,".cdf",sep="")

ncf <- nc_open(fileIn)

xkoord <- ncvar_get(ncf,varid = "longitude")
ykoord <- ncvar_get(ncf,varid = "latitude")

xkoord <- xkoord/1000.
ykoord <- ykoord/1000.

hoehen <- ncvar_get(ncf,varid = "height")


for (i in 1:length(zbahn)) {
  indxa<-findInterval(xbahn[i],xkoord)
  indya<-findInterval(ybahn[i],ykoord)
  wxa<-(xkoord[indxa+1]-xbahn[i])/(xkoord[indxa+1]-xkoord[indxa])
  wxb<-(xbahn[i]-xkoord[indxa])/(xkoord[indxa+1]-xkoord[indxa])
  wya<-(ykoord[indya+1]-ybahn[i])/(ykoord[indya+1]-ykoord[indya])
  wyb<-(ybahn[i]-ykoord[indya])/(ykoord[indya+1]-ykoord[indya])
  zerr[i] <- hoehen[indxa,indya]*wxa*wya+
    hoehen[indxa,indya+1]*wxa*wyb+
    hoehen[indxa+1,indya]*wxb*wya+
    hoehen[indxa+1,indya+1]*wxb*wyb-zbahn[i]
}

filename <- paste("Hoehenprofil",res,".png",sep="")

maxx <- max(xkoord)
minx <- min(xkoord)
maxy <- max(ykoord)
miny <- min(ykoord)
#minx <- 2573
#maxx <- 2575
#miny <- 1225
#maxy <- 1226

ratio <- (maxy-miny)/(maxx-minx)*1.1
width <- 820
height <- as.integer(width*ratio)

png(filename,width=width, height=height, units="px", pointsize=12)
filled.contour(xkoord,ykoord,
               hoehen, main="Vallon St-Imier",
               xlim=c(minx,maxx),
               ylim=c(miny,maxy),
#               xlim = range(xkoord),
#               ylim = range(ykoord),
               color.palette = terrain.colors)
lines(xbahn,ybahn,type="l")
dev.off()

zeiten <- rover$Timestamp

mittel <- mean(zerr)
print(mittel)
zerr <- zerr-mean(zerr)
pdf(file="FehlerHoehenmessung.pdf")
plot(zeiten,zerr,type="l",main = "Terrain",
     xlab="Time",ylab="Error Altitude")
dev.off()