library(ncdf4)

# Quelle der Daten: https://www.swisstopo.admin.ch/de/geodata/height/alti3d.html

# Aufloesung (Entweder 2 oder 0.5 m)
#res <- "2"
res <- "0.5"

# Vallon St-Imier
sektorX <- c(2573:2574)
sektorY <- c(1225:1225)

# Rhonegletscher
#sektorX <- c(2670:2675)
#sektorY <- c(1159:1167)

# Leeres Data-Frame initialisieren
columns = c("Xp","Yp","Zp") 
swisstopo = data.frame(matrix(nrow = 0, ncol = length(columns))) 
colnames(swisstopo) = columns

for (i in sektorX){
  for (j in sektorY){
    filename <- paste("../SwissTopo/",res,
                      "m/SWISSALTI3D_",res,"_XYZ_CHLV95_LN02_",
                      as.character(i),"_",
                      as.character(j),".xyz",sep="")
    swisstmp <- read.table(filename,header = TRUE,sep=" ")
    names(swisstmp) <- columns
    swisstopo <- rbind(swisstopo,swisstmp)
  }
}

swisstopo <- swisstopo[order(swisstopo$Yp,swisstopo$Xp),]

xkoord <- sort(unique(swisstopo$Xp))
ykoord <- sort(unique(swisstopo$Yp))

nx <- length(xkoord)
ny <- length(ykoord)

fileout <- paste("SWISS_ALTI3D_",res,".cdf",sep="")
x <- ncdim_def("longitude","Meter (Bern = 2600000)",xkoord)
y <- ncdim_def("latitude","Meter (Bern = 1200000)",ykoord)

height <- ncvar_def("height","Meter ueber Meer",list(x,y),-9.9999)

ncnew <- nc_create(fileout,height)
ncvar_put(ncnew,height,swisstopo$Zp,start=c(1,1),count=c(nx,ny))

nc_close(ncnew)
