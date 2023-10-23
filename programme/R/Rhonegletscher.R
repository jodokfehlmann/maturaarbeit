library(gplots)
library(ncdf4)

# https://www.swisstopo.admin.ch/de/geodata/height/alti3d.html

# Aufloesung (Entweder 2 oder 0.5 m)
res <- "2"
#res <- "0.5"

fileIn <- paste("SWISS_ALTI3D_",res,".cdf",sep="")

ncf <- nc_open(fileIn)

xkoord <- ncvar_get(ncf,varid = "longitude")
ykoord <- ncvar_get(ncf,varid = "latitude")

xkoord <- xkoord/1000.
ykoord <- ykoord/1000.

hoehen <- ncvar_get(ncf,varid = "height")

filename <- paste("Rhonegletscher",res,".png",sep="")

ratio <- (max(ykoord)-min(ykoord))/(max(xkoord)-min(xkoord))*1.1
width <- 820
height <- as.integer(width*ratio)

png(filename,width=width, height=height, units="px", pointsize=12)
filled.contour(xkoord,ykoord,
               hoehen, main="Rhonegletscher",
               xlim = range(xkoord),
               ylim = range(ykoord),
               color.palette = terrain.colors)
dev.off()

#width <- 8
#height <- as.integer(width*ratio)

#pdf(file = "Test.pdf",width=width, height=height)
#filled.contour(hoehen, main="Rhonegletscher",color.palette = terrain.colors)
#dev.off()
