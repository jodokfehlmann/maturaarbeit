import sys
import serial

port = 1
address = 0x76
serial_port = serial.Serial('/dev/serial0', 115200, timeout=1)

serial_port.flushInput()
serial_port.flushOutput()

gpsbaudfile = "/home/pi/.gps.baud"
fgps = open(gpsbaudfile,"r")
baud = int(fgps.readline())
fgps.close()


gpsfreqfile = "/home/pi/.gps.freq"
fgps = open(gpsfreqfile,"r")
freq = int(fgps.readline())
fgps.close()

#Frequenz
#outStr = '$PMTK220,1000*1F\r\n'
#outStr = '$PMTK220,200*2C\r\n'
if (baud==115200 and freq==1000):
   outStr = '$PMTK220,100*2F\r\n'
   serial_port.write(outStr.encode())
   fgps = open(gpsfreqfile,"w")
   fgps.write("100\n")
   fgps.close()
