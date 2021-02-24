#!/bin/sh

IO_CFGS="488-out 489-out 490-out 491-out"
IO_CFGS=$IO_CFGS" 492-in 493-in 494-in 495-in 496-in 497-in 498-in 499-in"
IO_CFGS=$IO_CFGS" 500-in 501-in 502-in 503-in 504-in 505-in 506-in 507-in"
IO_CFGS=$IO_CFGS" 508-out 509-out 510-out 511-out"
# AI switch gpio
IO_CFGS=$IO_CFGS" 135-out 136-out 192-out 196-out 127-out 133-out 134-out 197-out"
IO_CFGS=$IO_CFGS" 1-out 200-out 5-out 194-out 115-out 113-out 112-out 114-out"
IO_CFGS=$IO_CFGS" 21-out 111-out 109-out 107-out 106-out 108-out 110-out 17-out"
GpioExport() {

    for CFG in $IO_CFGS; do
        IO_NUM=$(echo $CFG | cut -d"-" -f1)
        IO_DIR=$(echo $CFG | cut -d"-" -f2)
        echo $IO_NUM >/sys/class/gpio/export
        echo $IO_DIR >/sys/class/gpio/gpio${IO_NUM}/direction
    done

}

GpioUnExport() {

    for CFG in $IO_CFGS; do
        IO_NUM=$(echo $CFG | cut -d"-" -f1)
        IO_DIR=$(echo $CFG | cut -d"-" -f2)
        echo $IO_NUM >/sys/class/gpio/unexport
        # echo $IO_DIR >/sys/class/gpio/gpio${IO_NUM}/direction
    done

}

case "$1" in
start)
    printf "Starting export gpio"
    GpioExport
    ;;
stop)
    printf "Stopping export gpio"
    GpioUnExport
    ;;
restart)
    printf "Restarting export gpio"
    GpioUnExport
    GpioExport
    ;;
*)
    echo "Usage: /etc/init.d/gpio.sh {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
