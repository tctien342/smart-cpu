#! /bin/bash

FILE_LOCATION="/tmp/smartcpu/notifier"
TIME_INTERVAL_TRACK=1
TEMP_NOTIFI=("" "")
IFS=$'\n'
mkdir -p /tmp/smartcpu
echo "false" >$FILE_LOCATION

notification() {
    osascript <<-AppleScript
display notification "$1" with title "Smart CPU" subtitle "$2"
AppleScript
}

while true; do
    TEMP="$(cat $FILE_LOCATION)"
    POS=0
    if [ "$TEMP" != "false" ]; then
        echo "<> Incomming notification"
        for i in $(</tmp/smartcpu/notifier); do
            TEMP_NOTIFI[$POS]=$i
            POS=$(($POS + 1))
        done
        notification ${TEMP_NOTIFI[0]} ${TEMP_NOTIFI[1]}
        echo "false" >$FILE_LOCATION
    fi
    sleep $TIME_INTERVAL_TRACK
done
