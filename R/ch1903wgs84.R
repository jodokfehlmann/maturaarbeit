# Vergleiche auch: https://www.swisstopo.admin.ch/de/karten-daten-online/calculation-services/navref.html

LV95_to_Grad <- function(E,N,Z){
yp<-E/1000000.-2.6
  xp<-N/1000000.-1.2
  
  lambdap<-2.6779094+
    4.728982*yp+
    0.791484*yp*xp+
    0.1306*yp*xp^2-
    0.0436*yp^3
  
  phip<-16.9023892+
    3.238272*xp-
    0.270978*yp^2-
    0.002528*xp^2-
    0.0447*yp^2*xp-
    0.0140*xp^3
  z <- Z + 49.55-
    12.60*yp-
    22.64*xp
  z <- Z
  lambdap <- lambdap*10000.  # Bogensekunden
  phip <- phip*10000.        # Bogensekunden

  lambdag <- lambdap/3600.
  phig    <- phip/3600.

  lambdagrad <- as.integer(lambdag)
  phigrad    <- as.integer(phig)

  lambdap    <- lambdap-3600.*lambdagrad
  phip       <- phip-3600.*phigrad
  
  lambdamin <- as.integer(lambdap/60.)
  phimin    <- as.integer(phip/60.)
  lambdasek <- round(lambdap-60.*lambdamin,digits=2)
  phisek    <- round(phip-60.*phimin,digits = 2)
  
  result <- rep(NA,3)
  result[1]<-paste(toString(lambdagrad),"o",
                   toString(lambdamin),"'",
                   toString(lambdasek),"''",sep="")
  result[2]<-paste(toString(phigrad),"o",
                   toString(phimin),"'",
                   toString(phisek),"''",sep="")
  result <- rep(NA,3)
  result[1]<-lambdag
  result[2]<-phig
  result[3]<-z
  return(result)
}


Grad_to_LV95 <- function(lon,lat,z){
  # Grad in Bogensekunden
  phi <- lat * 3600.
  lambda <- lon * 3600.
  phip <- (phi-169028.66)/10000.
  lambdap <- (lambda-26782.5)/10000.
  E <- 2600072.37+
    211455.93*lambdap-
    10938.51*lambdap*phip-
    0.36*lambdap*phip^2-
    44.54*lambdap^3
  N <- 1200147.07+
    308807.95*phip+
    3745.25*lambdap^2+
    76.63*phip^2-
    194.56*lambdap^2*phip+
    119.79*phip^3
  Z <- z-49.55+
    2.73*lambdap+
    6.94*phip
  Z <- z
  result <- rep(NA,3)
  result[1]<-E
  result[2]<-N
  result[3]<-Z
  return(result)
}

minutes2decimal <- function(x){
  gz <- as.integer(x)
  rem <- (x - gz)*5./3.
  return(gz+rem)
}


#print(Grad_to_LV95(7.06059,47.108538,680))
#print(LV95_to_Grad(2574000,1225000,680))