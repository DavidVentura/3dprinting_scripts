#!/bin/bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/is_printing.py

filename=Marlin.ino.hex
APIKEY="81A811D2D4094037AD9C69411B1AC73F"

echo building

~/Downloads/arduino-1.8.5/arduino --verify Marlin.ino --pref build.path=/tmp/build >/dev/null

echo disconnecting
curl -s 'http://octopi.labs/api/connection' -H 'Content-Type: application/json; charset=UTF-8' -H "X-Api-Key: $APIKEY" --data '{"command":"disconnect"}'

echo copying
scp /tmp/build/$filename  pi@octopi.labs: >/dev/null
#scp Marlin.ino.mega.hex  pi@octopi.labs:

echo building
ssh pi@octopi.labs "cd ~/arduino-1.8.5; ./hardware/tools/avr/bin/avrdude -p atmega2560 -C ./hardware/tools/avr/etc/avrdude.conf -c wiring -P /dev/ttyUSB0 -b 115200 -D -U flash:w:../$filename:i"

echo connecting
curl -s 'http://octopi.labs/api/connection' -H 'Content-Type: application/json; charset=UTF-8' -H "X-Api-Key: $APIKEY" --data '{"port":"/dev/ttyUSB0","baudrate":115200,"printerProfile":"_default","autoconnect":true,"command":"connect"}'
echo done
