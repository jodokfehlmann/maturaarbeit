import smbus
import sys
import serial
from datetime import datetime

i2c_ch = 1
address = 0x66
serial_port = serial.Serial('/dev/serial0', 115200, timeout=1)

i2c = smbus.SMBus(i2c_ch)

def write():
    try:
        i2c.write_byte_data(address,0x00,0x80)
        return 1
    except IOError:
        return 0

# Establish initial communication with the LIDAR
while (not write()):
    write()

logfile = "/home/pi/Documents/rover.log"
fgps = open(logfile,"a")

while True:
    try:
        gps_data = serial_port.readline().decode()
        if (gps_data.find('GPGGA') >= 0):
            reading = i2c.read_word_data(address, 0)
            reading = ((reading >> 8) | (reading << 8)) & 0xFFFF
            now = datetime.now()
            timestamp = now.strftime("%m/%d/%Y %H:%M:%S,%f")
            fgps.write(timestamp + ",")
            fgps.write(str(reading) + ",")
            fgps.write(gps_data)
            fgps.flush()
    except KeyboardInterrupt:
        sys.exit(0)
