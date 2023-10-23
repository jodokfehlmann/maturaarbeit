import sys
import serial
from datetime import datetime

port = 1
address = 0x76
serial_port = serial.Serial('/dev/serial0', 115200, timeout=1)

while True:
    try:
        gps_data = serial_port.readline().decode()
        if (gps_data.find('GPGGA') >= 0):
            now = datetime.now()
            timestamp = now.strftime("%m/%d/%Y %H:%M:%S,%f")
            print(timestamp + "," + gps_data)
    except KeyboardInterrupt:
        fgps.close()
        sys.exit(0)
