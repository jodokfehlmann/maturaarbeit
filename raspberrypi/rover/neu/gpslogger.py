import sys
import serial
from datetime import datetime

gpsfreqfile = "/home/pi/.gps.freq"
fgps = open(gpsfreqfile,"r")
freq = int(fgps.readline())
fgps.close()

if (freq != 100):
   sys.exit(1)


starten = datetime(2023,6,25,15,9)
stoppen = datetime(2023,6,25,19,1)
jetzt = datetime.now()
warten = (starten - jetzt).total_seconds()
restzeit = (stoppen - jetzt).total_seconds()

port = 1
address = 0x76
serial_port = serial.Serial('/dev/serial0', 115200, timeout=1)
gpslogfile = "/home/pi/Documents/gps_rover.log"
fgps = open(gpslogfile,"a")

while (warten > 0):
    jetzt = datetime.now()
    warten = (starten - jetzt).total_seconds()

while (restzeit > 0):
    jetzt = datetime.now()
    restzeit = (stoppen - jetzt).total_seconds()
    try:
        gps_data = serial_port.readline().decode()
        if (gps_data.find('GPGGA') >= 0):
            now = datetime.now()
            timestamp = now.strftime("%m/%d/%Y %H:%M:%S,%f")
            fgps.write(timestamp + ",")
            fgps.write(gps_data)
            fgps.flush()
    except KeyboardInterrupt:
        fgps.close()
        sys.exit(0)
