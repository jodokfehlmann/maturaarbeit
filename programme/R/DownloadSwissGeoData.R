# Quelle der Daten: https://www.swisstopo.admin.ch/de/geodata/height/alti3d.html

# Aufloesung (Entweder 2 oder 0.5 m)
#res <- "2"
res <- "0.5"

# Vallon St-Imier
urlfile <- paste("../SwissTopo/",res,"m/LinksVallonStImier",res,".csv",sep="")
download_link <- read.table(urlfile,colClasses = "character")
names(download_link) <- c("url")
destfile <- "tmpfile.zip"
for (i in 1:length(download_link$url)){
  url <- download_link$url[i]
  download.file(url,destfile)
  unzip(destfile)
  file.remove(destfile)
}
