library(ncdf4)
library(rayshader)

# https://www.swisstopo.admin.ch/de/geodata/height/alti3d.html

# Aufloesung (Entweder 2 oder 0.5 m)
res <- "2"
#res <- "0.5"

fileIn <- paste("SWISS_ALTI3D_",res,".cdf",sep="")

ncf <- nc_open(fileIn)

xkoord <- ncvar_get(ncf,varid = "longitude")
ykoord <- ncvar_get(ncf,varid = "latitude")
nx <- length(xkoord)
ny <- length(ykoord)

tmp <- ncvar_get(ncf,varid = "height")
elmat <- tmp
for (i in c(1:nx)){
   for (j in c(1:ny)){
      elmat[i,j] <- tmp[nx+1-i,j]
   }
}

#elmat %>%
#  sphere_shade(texture = "desert") %>%
#  add_water(detect_water(elmat), color = "desert") %>%
#  add_shadow(ray_shade(elmat), 0.5) %>%
#  add_shadow(ambient_shade(elmat), 0) %>%
#  plot_map()

elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat, zscale = 3), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0) %>%
  plot_3d(elmat, zscale = 10, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
Sys.sleep(0.2)
render_snapshot()