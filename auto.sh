#! /bin/bash
######### BEGIN OF DEFAULT CONFIG #########
# EXTRA BATTERY PROFILE 0               <EXTRA LOW BATTERY USAGE>
EX_BATTERY_LONG="0"  # Long period power usage of cpu W
EX_BATTERY_SHORT="0" # Short period power usage of cpu W
EX_BATTERY_TURBO="1" # Intel turbo on/off <Off>
# BATTERY USAGE PROFILE 1               <LOW BATTARY USAGE AND COOL>
BATTERY_LONG="0"  # Long period power usage of cpu W
BATTERY_SHORT="0" # Short period power usage of cpu W
BATTERY_TURBO="1" # Intel turbo on/off <Off>
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
# SETTING AUTO PROFILE ON BATTERY LOW
BATTERY_LOW_PERCENT=20 # Setting percent when battery is low
BATTERY_LOW_PROFILES=0 # When battery low will setting this profile
# SETTING INIT PROFILE
BATTERY_PROFILE=1 # On battery will select this profile
PLUGIN_PROFILE=3  # On plugin will select this profile
# UNDERVOLT
# Setting to undervolt CPU -> Colddown (mha)
# Config this must carefully, can damage your cpu ( set to 0 if you want to bypass )
CPU_VOLT="0"
GPU_VOLT="0"
CPU_CACHE_VOLT="0"
######### END OF DEFAULT CONFIG #########

######### PROGRAM START #########
# Default script value
declare -i TICK=0
declare -i PROFILE=0             # Init profile position
declare -i LOW_TICK=0            # Tick before shutdown the computer
declare -i ALERT_PERCENT=5       # Battery percent before shut down system
declare -i TIME_INTERVAL_TRACK=2 # Time will check battery status again
MAX_PROFILE=5                    # Max profile have
MAX_TICK_SET_VOLT_AGAIN=900      # About 30min = 900*2 second
MAX_TICK_SHUTDOWN=30             # About 1min = 30*2 second
SLEEP_STATUS=0                   # Sleep status 0 is wake ( 1 is sleeping )

# Declare binary
if [[ -d "/Library/Application Support/VoltageShift/" ]]; then
    BIN_LOCATION="/Library/Application\ Support/VoltageShift/voltageshift"
    # Import config from config file
    source /Library/Application\ Support/VoltageShift/config.sh
    DEBUG="false"
else
    BIN_LOCATION="./voltageshift"
    # Import config from config file
    source ./config.sh
    DEBUG="true"
fi

# Init value for bitbar
mkdir -p /Users/Shared/.smartcpu
echo "init" >"/Users/Shared/.smartcpu/profile_name"
echo "-1" >"/Users/Shared/.smartcpu/profile"
echo "0 0 0" >"/Users/Shared/.smartcpu/config"
echo "" >"/Users/Shared/.smartcpu/setting"

# Send and notification for user with input: Content and subcontent
notification() {
    if [[ -f "/Users/Shared/.smartcpu/notification" ]]; then
        NOTIFI="$(cat /Users/Shared/.smartcpu/notification)"
    else
        NOTIFI=1
    fi
    if [ "$NOTIFI" -eq 1 ]; then
        echo "$1" >/Users/Shared/.smartcpu/notifier
        echo "$2" >>/Users/Shared/.smartcpu/notifier
    fi
}
# Force using notfication, emergency alert
notification_force() {
    echo "$1" >/Users/Shared/.smartcpu/notifier
    echo "$2" >>/Users/Shared/.smartcpu/notifier
}

# Get current battery percent
get_bat_percent() {
    echo "$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
}

# Get lid status
get_lid_open_status() {
    LID_OPEN_STATUS="$(ioreg -r -k AppleClamshellState | grep '"AppleClamshellState"' | cut -f2 -d"=")"
    if [[ $LID_OPEN_STATUS == *"No"* ]]; then
        echo "1"
    else
        echo "0"
    fi
}

# Get sleep status
get_sleep_status() {
    CURRENT_POWER=$(($(ioreg -n IODisplayWrangler | grep -i IOPowerManagement | perl -pe 's/^.*DevicePowerState\"=([0-9]+).*$/\1/')))
    if [ $CURRENT_POWER -eq $((4)) ]; then
        echo "0"
    else
        echo "1"
    fi
}

# Shutdown your system
shut_down() {
    TEMP="$(osascript -e 'tell app "System Events" to shut down')"
}

# Init all profile setting
extra_battery_mode() {
    echo "Extra Battery" >"/Users/Shared/.smartcpu/profile_name"
    echo "0" >"/Users/Shared/.smartcpu/profile"
    echo "$EX_BATTERY_LONG" >"/Users/Shared/.smartcpu/config"
    echo "$EX_BATTERY_SHORT" >>"/Users/Shared/.smartcpu/config"
    echo "$EX_BATTERY_TURBO" >>"/Users/Shared/.smartcpu/config"
    echo "<p> Switching to Extra Battery Mode"
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
    echo "<p> Switching to Battery Mode"
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
    echo "<p> Switching to Normal Mode"
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
    echo "<p> Switching to Performance Mode"
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
    echo "<p> Switching to Extra Performance Mode"
    notification "Enter extra performane mode!" "Hardcore task, building apps, maxout your cpu."
    TEMP="$(eval $BIN_LOCATION power $EX_PERFORMANCE_LONG $EX_PERFORMANCE_SHORT)"
    TEMP="$(eval $BIN_LOCATION turbo $EX_PERFORMANCE_TURBO)"
}

# Add value to file on start for birbar plugin read
init_value_to_file() {
    echo "$EX_BATTERY_SHORT $EX_BATTERY_LONG $EX_BATTERY_TURBO" >"/Users/Shared/.smartcpu/setting"
    echo "$BATTERY_SHORT $BATTERY_LONG $BATTERY_TURBO" >>"/Users/Shared/.smartcpu/setting"
    echo "$NORMAL_SHORT $NORMAL_LONG $NORMAL_TURBO" >>"/Users/Shared/.smartcpu/setting"
    echo "$PERFORMANCE_SHORT $PERFORMANCE_LONG $PERFORMANCE_TURBO" >>"/Users/Shared/.smartcpu/setting"
    echo "$EX_PERFORMANCE_SHORT $EX_PERFORMANCE_LONG $EX_PERFORMANCE_TURBO" >>"/Users/Shared/.smartcpu/setting"
    echo "$CPU_VOLT $GPU_VOLT $CPU_CACHE_VOLT" >>"/Users/Shared/.smartcpu/setting"
}

# Switch profile function
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
init_value_to_file
TEMP="$(eval $BIN_LOCATION offset $CPU_VOLT $GPU_VOLT $CPU_CACHE_VOLT)"
echo "<a> Created by saintno"
if [ $DEBUG == "true" ]; then
    echo "<m> Console mode"
else
    echo "<m> Installed mode"
fi
echo "<m> Init config"
echo "  <i> EXTRA BATTERY MODE: L$EX_BATTERY_LONG S$EX_BATTERY_SHORT TURBO $EX_BATTERY_TURBO"
echo "  <i> BATTERY MODE: L$BATTERY_LONG S$BATTERY_SHORT TURBO $BATTERY_TURBO"
echo "  <i> NORMAL MODE: L$NORMAL_LONG S$NORMAL_SHORT TURBO $NORMAL_TURBO"
echo "  <i> PERFORMANCE MODE: L$PERFORMANCE_LONG S$PERFORMANCE_SHORT TURBO $PERFORMANCE_TURBO"
echo "  <i> EXTRA PERFORMANCE MODE: L$EX_PERFORMANCE_LONG S$EX_PERFORMANCE_SHORT TURBO $EX_PERFORMANCE_TURBO"
echo "  <i> VOLTAGE OFFSET: CPU $CPU_VOLT mv & GPU $GPU_VOLT mv & CPU CACHE $CPU_CACHE_VOLT mv"
BATTERY_STATUS="$(pmset -g batt | grep 'Battery Power')"
if [[ $BATTERY_STATUS == *"Battery Power"* ]]; then
    PLUG_IN="false"
    echo "true" >"/Users/Shared/.smartcpu/battery"
    PROFILE=BATTERY_PROFILE
    select_profile
else
    PLUG_IN="true"
    echo "false" >"/Users/Shared/.smartcpu/battery"
    PROFILE=PLUGIN_PROFILE
    select_profile
fi

# Listener stage
while true; do
    # Re switch profile after wake
    SLEEP_VALUE=$(get_sleep_status)
    if [ $(($get_sleep_status)) -ne $(($SLEEP_STATUS)) ]; then
        SLEEP_STATUS=$(($SLEEP_VALUE))
        if [ $(($SLEEP_VALUE)) -eq $((0)) ]; then
            select_profile
        fi
    fi

    # Only auto select value on wake
    if [ $(($SLEEP_STATUS)) -eq $((0)) ]; then
        # Getting current value
        TICK=$((TICK + 1))
        BATTERY_STATUS="$(pmset -g batt | grep 'Battery Power')"
        BATTERY_LEVEL=$(get_bat_percent)
        if [[ -f "/Users/Shared/.smartcpu/auto_shut" ]]; then
            AUTO_SHUT="$(cat /Users/Shared/.smartcpu/auto_shut)"
        else
            AUTO_SHUT=0
        fi

        # Run checking status
        if [ $TICK == $MAX_TICK_SET_VOLT_AGAIN ]; then
            echo "<> Reset voltage offset"
            TEMP="$(eval $BIN_LOCATION offset $CPU_VOLT $GPU_VOLT $CPU_CACHE_VOLT)"
            TICK=$((0))
        fi
        if [[ $BATTERY_STATUS == *"Battery Power"* ]]; then
            if [ $PLUG_IN == "true" ]; then
                PLUG_IN="false"
                echo "true" >"/Users/Shared/.smartcpu/battery"
                PROFILE=BATTERY_PROFILE
                select_profile
            else
                if [ $(($BATTERY_LEVEL)) -le $(($BATTERY_LOW_PERCENT)) ] && [ $PROFILE -ne $BATTERY_LOW_PROFILES ]; then
                    echo "<!> Low battery detected"
                    PROFILE=0
                    select_profile
                fi
                if [ $(($BATTERY_LEVEL)) -le $(($ALERT_PERCENT)) ] && [ "$AUTO_SHUT" -eq 1 ]; then
                    if [ $LOW_TICK -eq $(($MAX_TICK_SHUTDOWN)) ]; then
                        echo "<!> Shutting down..."
                        shut_down
                    else
                        if [ $(expr $LOW_TICK % 10) -eq 0 ]; then
                            TIME_LEFT=$(expr $(expr $(($MAX_TICK_SHUTDOWN)) - $LOW_TICK) \* 2)
                            echo "<!> Battery critical! Shutting down in $TIME_LEFT second."
                            notification_force "Battery critical!" "Your computer will shutdown in $TIME_LEFT second. Please connect your power adapter!"
                        fi
                        LOW_TICK=$((LOW_TICK + 1))
                    fi
                fi
            fi
        else
            if [ $PLUG_IN == "false" ]; then
                PLUG_IN="true"
                echo "false" >"/Users/Shared/.smartcpu/battery"
                PROFILE=PLUGIN_PROFILE
                select_profile
                if [ $LOW_TICK -ne 0 ]; then
                    LOW_TICK=$((0))
                fi
            fi
        fi
    else
        # Allow to shutdown when battery is low when sleeping
        if [[ $BATTERY_STATUS == *"Battery Power"* ]]; then
            if [ $(($BATTERY_LEVEL)) -le $(($ALERT_PERCENT)) ] && [ "$AUTO_SHUT" -eq 1 ]; then
                echo "<!> Shutting down..."
                shut_down
            fi
        fi
    fi

    # Check if setting from bitbar
    TEMP_PROFILE="$(cat /Users/Shared/.smartcpu/profile)"
    if [ $PROFILE != $TEMP_PROFILE ]; then
        PROFILE=$TEMP_PROFILE
        select_profile
    fi
    sleep $TIME_INTERVAL_TRACK
done
