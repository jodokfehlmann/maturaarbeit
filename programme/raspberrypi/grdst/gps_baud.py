import sys
import serial

port = 1
address = 0x76
serial_port = serial.Serial('/dev/serial0', 9600, timeout=1)

serial_port.flushInput()
serial_port.flushOutput()

gpsbaudfile = "/home/pi/.gps.baud"
fgps = open(gpsbaudfile,"r")
baud = int(fgps.readline())
fgps.close()

#Baudrate
#outStr = '$PMTK251,9600*17\r\n'
#outStr = '$PMTK251,38400*27\r\n'

if (baud==9600):
   outStr = '\$PMTK251,115200*1F\r\n'
   serial_port.write(outStr.encode())
   fgps = open(gpsbaudfile,"w")
   fgps.write("115200\n")
   fgps.close()
