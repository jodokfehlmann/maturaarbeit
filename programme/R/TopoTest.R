library(gplots)
library(ncdf4)

# https://www.swisstopo.admin.ch/de/geodata/height/alti3d.html

ncf <- nc_open("SWISS_ALTI3D_0.5.cdf")

xkoord <- ncvar_get(ncf,varid = "longitude")
ykoord <- ncvar_get(ncf,varid = "latitude")

nx <- dim(xkoord)
ny <- dim(ykoord)

hoehen <- ncvar_get(ncf,varid = "height")

filename <- "Test.png"

ratio <- (max(ykoord)-min(ykoord))/(max(xkoord)-min(xkoord))
width <- 820
height <- as.integer(width*ratio)

png(filename,width=width, height=height, units="px", pointsize=12)
filled.contour(hoehen, main="Cortébert",color.palette = terrain.colors)
dev.off()

width <- 8
height <- as.integer(width*ratio)

pdf(file = "Test.pdf",width=width, height=height)
filled.contour(hoehen, main="Cortébert",color.palette = terrain.colors)
dev.off()
