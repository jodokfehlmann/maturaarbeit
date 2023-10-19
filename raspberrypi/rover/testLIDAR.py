import smbus
import sys
import time

i2c_ch = 1
address = 0x66


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

while True:
   reading = i2c.read_word_data(address, 0)
   reading = ((reading >> 8) | (reading << 8)) & 0xFFFF

   print(reading)
   time.sleep(0.1)

