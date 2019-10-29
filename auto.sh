#! /bin/bash

# Default script value
declare -i TICK=0
declare -i PROFILE=0 # Init profile position
MAX_PROFILE=5       # Max profile have
if [[ -d "/Library/Application Support/VoltageShift/" ]]; then
    BIN_LOCATION="/Library/Application\ Support/VoltageShift/voltageshift"
    DEBUG="false"
else
    BIN_LOCATION="./voltageshift"
    DEBUG="true"
fi
mkdir -p /Users/Shared/.smartcpu
echo "init" >"/Users/Shared/.smartcpu/profile_name"
echo "-1" >"/Users/Shared/.smartcpu/profile"
echo "0 0 0" >"/Users/Shared/.smartcpu/config"
declare -i TIME_INTERVAL_TRACK=2 # Time will check battery status again
MAX_TICK_SET_VOLT_AGAIN=900      # About 30min = 900*2 second

# Init your config here
# All W value should be below your CPU TPD, you can not overclock cpu with this value
# Find your value in intel page like this
# 9300H: https://www.intel.vn/content/www/vn/vi/products/processors/core/i5-processors/i5-9300h.html

# EXTRA BATTERY PROFILE 0               <EXTRA LOW BATTERY USAGE>
EX_BATTERY_LONG="0"   # Long period power usage of cpu W
EX_BATTERY_SHORT="0" # Short period power usage of cpu W
EX_BATTERY_TURBO="0"  # Intel turbo on/off <Off>
# BATTERY USAGE PROFILE 1               <LOW BATTARY USAGE AND COOL>
BATTERY_LONG="0"  # Long period power usage of cpu W
BATTERY_SHORT="0" # Short period power usage of cpu W
BATTERY_TURBO="0"  # Intel turbo on/off <Off>
# NORMAL USAGE PROFILE 2                <SMOOTHEST AND COOL>
NORMAL_LONG="0"
NORMAL_SHORT="0"
NORMAL_TURBO="1"
# PERFORMANCE USAGE PROFILE 3           <PERFORMANCE COOL>
PERFORMANCE_LONG="0"
PERFORMANCE_SHORT="0"
PERFORMANCE_TURBO="1"
# EXTRA PERFORMANCE USAGE PROFILE 4     <PERFORMANCE MAX>
EX_PERFORMANCE_LONG="0"
EX_PERFORMANCE_SHORT="0"
EX_PERFORMANCE_TURBO="1"
# SETTING INIT PROFILE
BATTERY_PROFILE=1 # On battery will select this profile
PLUGIN_PROFILE=4  # On plugin will select this profile
# Setting to undervolt CPU -> Colddown (mha)
# Config and this this carefully ( set to 0 if you want to bypass )
CPU_VOLT="-0"
GPU_VOLT="-0"

# Send and notification for user with input: Content and subcontent
notification() {
    echo "$1" >/Users/Shared/.smartcpu/notifier
    echo "$2" >>/Users/Shared/.smartcpu/notifier
}

get_bat_percent() {
    echo "$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
}

extra_battery_mode() {
    echo "Extra Battery" >"/Users/Shared/.smartcpu/profile_name"
    echo "0" >"/Users/Shared/.smartcpu/profile"
    echo "$EX_BATTERY_LONG" >"/Users/Shared/.smartcpu/config"
    echo "$EX_BATTERY_SHORT" >>"/Users/Shared/.smartcpu/config"
    echo "$EX_BATTERY_TURBO" >>"/Users/Shared/.smartcpu/config"
    echo ">> Switching to Extra Battery Mode"
    notification "Enter extra battery mode!" "Web browsing, web developer, low usage of cpu."
    TEMP="$(eval $BIN_LOCATION power $EX_BATTERY_LONG $EX_BATTERY_SHORT)"
    TEMP="$(eval $BIN_LOCATION turbo $EX_BATTERY_TURBO)"
}

battery_mode() {
    echo "Battery" >"/Users/Shared/.smartcpu/profile_name"
    echo "1" >"/Users/Shared/.smartcpu/profile"
    echo "$BATTERY_LONG" >"/Users/Shared/.smartcpu/config"
    echo "$BATTERY_SHORT" >>"/Users/Shared/.smartcpu/config"
    echo "$BATTERY_TURBO" >>"/Users/Shared/.smartcpu/config"
    echo ">> Switching to Battery Mode"
    notification "Enter battery mode!" "Low cpu power for better usage time, light coding."
    TEMP="$(eval $BIN_LOCATION power $BATTERY_LONG $BATTERY_SHORT)"
    TEMP="$(eval $BIN_LOCATION turbo $BATTERY_TURBO)"
}

normal_mode() {
    echo "Normal" >"/Users/Shared/.smartcpu/profile_name"
    echo "2" >"/Users/Shared/.smartcpu/profile"
    echo "$NORMAL_LONG" >"/Users/Shared/.smartcpu/config"
    echo "$NORMAL_SHORT" >>"/Users/Shared/.smartcpu/config"
    echo "$NORMAL_TURBO" >>"/Users/Shared/.smartcpu/config"
    echo ">> Switching to Normal Mode"
    notification "Enter normal mode!" "Normal cpu power for daily usage, daily task."
    TEMP="$(eval $BIN_LOCATION power $NORMAL_LONG $NORMAL_SHORT)"
    TEMP="$(eval $BIN_LOCATION turbo $NORMAL_TURBO)"
}

performance_mode() {
    echo "Performance" >"/Users/Shared/.smartcpu/profile_name"
    echo "3" >"/Users/Shared/.smartcpu/profile"
    echo "$PERFORMANCE_LONG" >"/Users/Shared/.smartcpu/config"
    echo "$PERFORMANCE_SHORT" >>"/Users/Shared/.smartcpu/config"
    echo "$PERFORMANCE_TURBO" >>"/Users/Shared/.smartcpu/config"
    echo ">> Switching to Performance Mode"
    notification "Enter performane mode!" "High cpu power, medium task without too hot."
    TEMP="$(eval $BIN_LOCATION power $PERFORMANCE_LONG $PERFORMANCE_SHORT)"
    TEMP="$(eval $BIN_LOCATION turbo $PERFORMANCE_TURBO)"
}

extra_performance_mode() {
    echo "Extra Performance" >"/Users/Shared/.smartcpu/profile_name"
    echo "4" >"/Users/Shared/.smartcpu/profile"
    echo "$EX_PERFORMANCE_LONG" >"/Users/Shared/.smartcpu/config"
    echo "$EX_PERFORMANCE_SHORT" >>"/Users/Shared/.smartcpu/config"
    echo "$EX_PERFORMANCE_TURBO" >>"/Users/Shared/.smartcpu/config"
    echo ">> Switching to Extra Performance Mode"
    notification "Enter extra performane mode!" "Hardcore task, building apps, maxout your cpu."
    TEMP="$(eval $BIN_LOCATION power $EX_PERFORMANCE_LONG $EX_PERFORMANCE_SHORT)"
    TEMP="$(eval $BIN_LOCATION turbo $EX_PERFORMANCE_TURBO)"
}

select_profile() {
    case $PROFILE in
    0)
        extra_battery_mode
        ;;
    1)
        battery_mode
        ;;
    2)
        normal_mode
        ;;
    3)
        performance_mode
        ;;
    4)
        extra_performance_mode
        ;;
    *)
        normal_mode
        ;;
    esac
}

# Init stage
TEMP="$(eval $BIN_LOCATION offset $CPU_VOLT $GPU_VOLT $CPU_VOLT)"
echo "<> Created by saintno"
if [ $DEBUG == "true" ]; then
    echo "<> Console mode"
else
    echo "<> Installed mode"
fi
echo "<> Init config"
echo "  >> EXTRA BATTERY MODE: L$EX_BATTERY_LONG S$EX_BATTERY_SHORT TURBO $EX_BATTERY_TURBO"
echo "  >> BATTERY MODE: L$BATTERY_LONG S$BATTERY_SHORT TURBO $BATTERY_TURBO"
echo "  >> NORMAL MODE: L$NORMAL_LONG S$NORMAL_SHORT TURBO $NORMAL_TURBO"
echo "  >> PERFORMANCE MODE: L$PERFORMANCE_LONG S$PERFORMANCE_SHORT TURBO $PERFORMANCE_TURBO"
echo "  >> EXTRA PERFORMANCE MODE: L$EX_PERFORMANCE_LONG S$EX_PERFORMANCE_SHORT TURBO $EX_PERFORMANCE_TURBO"
echo "  >> VOLTAGE OFFSET: CPU $CPU_VOLT mha & GPU $GPU_VOLT mha"
BATTERY_STATUS="$(pmset -g batt | grep 'Battery Power')"
if [[ $BATTERY_STATUS == *"Battery Power"* ]]; then
    PLUG_IN="false"
    PROFILE=BATTERY_PROFILE
    select_profile
else
    PLUG_IN="true"
    PROFILE=PLUGIN_PROFILE
    select_profile
fi

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
            PROFILE=BATTERY_PROFILE
            select_profile
        fi
    else
        if [ $PLUG_IN == "false" ]; then
            PLUG_IN="true"
            PROFILE=PLUGIN_PROFILE
            select_profile
        fi
    fi
    TEMP_PROFILE="$(cat /Users/Shared/.smartcpu/profile)"
    if [ $PROFILE != $TEMP_PROFILE ]; then
        PROFILE=$TEMP_PROFILE
        select_profile
    fi
    sleep $TIME_INTERVAL_TRACK
done
