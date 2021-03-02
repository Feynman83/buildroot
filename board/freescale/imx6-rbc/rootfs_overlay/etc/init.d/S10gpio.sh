#!/bin/sh

IO_CFGS="488-out-do1 489-out-do2 490-out-do3 491-out-do4"
IO_CFGS=$IO_CFGS" 492-in-di1 493-in-di2 494-in-di3 495-in-di4 496-in-di5 497-in-di6 498-in-di7 499-in-di8"
# IO_CFGS=$IO_CFGS" 500-in-di9 501-in-di10 502-in-di11 503-in-di12 504-in-di13 505-in-di14 506-in-di15 507-in-di16"
IO_CFGS=$IO_CFGS" 505-in-di9 503-in-di10 502-in-di11 500-in-di12 507-in-di13 506-in-di14 504-in-di15 501-in-di16"
IO_CFGS=$IO_CFGS" 511-out-uart1_sw 509-out-uart2_sw 508-out-uart3_sw 510-out-uart4_sw"
# AI switch gpio
IO_CFGS=$IO_CFGS" 135-out-av1_sw 136-out-av2_sw 192-out-av3_sw 196-out-av4_sw 127-out-av5_sw 133-out-av6_sw 134-out-av7_sw 197-out-av8_sw"
IO_CFGS=$IO_CFGS" 1-out-av9_sw 200-out-av10_sw 5-out-av11_sw 194-out-av12_sw 115-out-av13_sw 113-out-av14_sw 112-out-av15_sw 114-out-av16_sw"
IO_CFGS=$IO_CFGS" 21-out-av17_sw 111-out-av18_sw 109-out-av19_sw 107-out-av20_sw 106-out-av21_sw 108-out-av22_sw 110-out-av23_sw 17-out-av24_sw"
#bat switch
IO_CFGS=$IO_CFGS" 198-out-bat_sw"

GpioExport() {

    mkdir -p /dev/gpio
    for CFG in $IO_CFGS; do
        IO_NUM=$(echo $CFG | cut -d"-" -f1)
        IO_DIR=$(echo $CFG | cut -d"-" -f2)
        IO_ALIAS=$(echo $CFG | cut -d"-" -f3)
        echo $IO_NUM >/sys/class/gpio/export
        echo $IO_DIR >/sys/class/gpio/gpio${IO_NUM}/direction
        ln -s /sys/class/gpio/gpio${IO_NUM} /dev/gpio/${IO_ALIAS}
    done

}

GpioUnExport() {
    rm -rf /dev/gpio
    for CFG in $IO_CFGS; do
        IO_NUM=$(echo $CFG | cut -d"-" -f1)
        IO_DIR=$(echo $CFG | cut -d"-" -f2)
        echo $IO_NUM >/sys/class/gpio/unexport
        # echo $IO_DIR >/sys/class/gpio/gpio${IO_NUM}/direction
    done

}

ADCCFG="0-0-av1 0-1-av2 0-2-av3 0-3-av4 0-4-av5 0-5-av6 0-6-av7 0-7-av8"
ADCCFG=$ADCCFG" 1-0-av9 1-1-av10 1-2-av11 1-3-av12 1-4-av13 1-5-av14 1-6-av15 1-7-av16"
ADCCFG=$ADCCFG" 2-0-av17 2-1-av18 2-2-av19 2-3-av20 2-4-av21 2-5-av22 2-6-av23 2-7-av24"
ADCCFG=$ADCCFG" 3-0-bat1 3-1-bat2"
ADCExport() {
    mkdir -p /dev/adc
    for CFG in $ADCCFG; do

        AD_NUM=$(echo $CFG | cut -d"-" -f1)
        AD_CH=$(echo $CFG | cut -d"-" -f2)
        AD_ALIAS=$(echo $CFG | cut -d"-" -f3)
        ln -s /sys/bus/iio/devices/iio:device${AD_NUM}/in_voltage${AD_CH}_raw /dev/adc/${AD_ALIAS}

    done
}

ADCUnExport() {
    rm -rf /dev/adc
}

case "$1" in
start)
    printf "Starting export gpio"
    GpioExport
    ADCExport
    echo "OK"
    ;;
stop)
    printf "Stopping export gpio"
    GpioUnExport
    ADCUnExport
    echo "OK"
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
