#! /bin/bash

# Default script value
declare -i TICK=0
if [[ -d "/Library/Application Support/VoltageShift/" ]]; then
    BIN_LOCATION="/Library/Application\ Support/VoltageShift/voltageshift"
    DEBUG="false"
else
    BIN_LOCATION="./voltageshift"
    DEBUG="true"
fi

# Init your config here
declare -i TIME_INTERVAL_TRACK=2 # Time will check battery status again
MAX_TICK_SET_VOLT_AGAIN=900      # About 30min = 900*2 second

# On battery config
BATTERY_LONG="0"  # Long period power usage of cpu W: 15W for my 9300H
BATTERY_SHORT="0" # Short period power usage of cpu W 20W for my 9300H
BATTERY_TURBO="0" # Intel turbo on/off <Off>
# On plugin config in W
PLUGIN_LONG="0"  # 35 for my 9300H
PLUGIN_SHORT="0" # 40 for my 9300H
PLUGIN_TURBO="1"
# Setting to undervolt CPU -> Colddown (mha)
CPU_VOLT="-0" # -120 for my 9300H
GPU_VOLT="-0" # -90 for my 9300H

# Init stage
TEMP="$(eval $BIN_LOCATION offset $CPU_VOLT $GPU_VOLT $CPU_VOLT)"
echo "<> Created by saintno"
if [ $DEBUG == "true" ]; then
    echo "<> Console mode"
else
    echo "<> Installed mode"
fi
echo "<> Init config"
echo "  >> BATTERY MODE: L$BATTERY_LONG S$BATTERY_SHORT TURBO $BATTERY_TURBO"
echo "  >> PLUGIN MODE: L$PLUGIN_LONG S$PLUGIN_SHORT TURBO $PLUGIN_TURBO"
echo "  >> VOLTAGE OFFSET: CPU $CPU_VOLT mha & GPU $GPU_VOLT mha"
BATTERY_STATUS="$(pmset -g batt | grep 'Battery Power')"
if [[ $BATTERY_STATUS == *"Battery Power"* ]]; then
    PLUG_IN="false"
    echo "<> Started with battery mode"
    if [ $BATTERY_LONG == "0" ] || [ $BATTERY_SHORT == "0" ]; then
        echo ">>> Battery mode not config yet"
    else
        TEMP="$(eval $BIN_LOCATION power $BATTERY_LONG $BATTERY_SHORT)"
        TEMP="$(eval $BIN_LOCATION turbo $BATTERY_TURBO)"
    fi
else
    PLUG_IN="true"
    echo "<> Started with plugin mode"
    if [ $PLUGIN_LONG == "0" ] || [ $PLUGIN_SHORT == "0" ]; then
        echo ">>> Plugin mode not config yet"
    else
        TEMP="$(eval $BIN_LOCATION power $PLUGIN_LONG $PLUGIN_SHORT)"
        TEMP="$(eval $BIN_LOCATION turbo $PLUGIN_TURBO)"
    fi
fi

notification_battery() {
    osascript <<-AppleScript
display notification "Enter battery mode" with title "Smart CPU" 
AppleScript
}

notification_plugin() {
    osascript <<-AppleScript
display notification "Enter plugin mode" with title "Smart CPU" 
AppleScript
}

# Listener stage
while true; do
    TICK=$((TICK + 1))
    BATTERY_STATUS="$(pmset -g batt | grep 'Battery Power')"

    if [ $TICK == $MAX_TICK_SET_VOLT_AGAIN ]; then
        echo "<> Reset voltage offset"
        TEMP="$(eval $BIN_LOCATION offset $CPU_VOLT $GPU_VOLT $CPU_VOLT)"
        TICK=$((0))
    fi
    if [[ $BATTERY_STATUS == *"Battery Power"* ]]; then
        if [ $PLUG_IN == "true" ]; then
            PLUG_IN="false"
            echo ">> Switching to Battery Mode"
            if [ $BATTERY_LONG == "0" ] || [ $BATTERY_SHORT == "0" ]; then
                echo ">>> Battery mode not config yet"
            else
                notification_battery
                TEMP="$(eval $BIN_LOCATION power $BATTERY_LONG $BATTERY_SHORT)"
                TEMP="$(eval $BIN_LOCATION turbo $BATTERY_TURBO)"
            fi
        fi
    else
        if [ $PLUG_IN == "false" ]; then
            PLUG_IN="true"
            echo ">> Switching to Plugin Mode"
            if [ $PLUGIN_LONG == "0" ] || [ $PLUGIN_SHORT == "0" ]; then
                echo ">>> Plugin mode not config yet"
            else
                notification_plugin
                TEMP="$(eval $BIN_LOCATION power $PLUGIN_LONG $PLUGIN_SHORT)"
                TEMP="$(eval $BIN_LOCATION turbo $PLUGIN_TURBO)"
            fi
        fi
    fi
    sleep $TIME_INTERVAL_TRACK
done
