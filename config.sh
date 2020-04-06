######### BEGIN OF YOUR CONFIG #########
# All power value should be below your CPU TPD, you can not overclock cpu with this value
# Find your value in intel page like this
# 9300H: https://www.intel.vn/content/www/vn/vi/products/processors/core/i5-processors/i5-9300h.html

# EXTRA BATTERY PROFILE 0               <EXTRA LOW BATTERY USAGE>
EX_BATTERY_LONG="0"         # Long period power usage of cpu W
EX_BATTERY_SHORT="0"        # Short period power usage of cpu W
EX_BATTERY_TURBO="1"        # Intel turbo on/off <Off>
# BATTERY USAGE PROFILE 1               <LOW BATTARY USAGE AND COOL>
BATTERY_LONG="0"            # Long period power usage of cpu W
BATTERY_SHORT="0"           # Short period power usage of cpu W
BATTERY_TURBO="1"           # Intel turbo on/off <Off>
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
BATTERY_LOW_PERCENT=20      # Setting percent when battery is low
BATTERY_LOW_PROFILES=0      # When battery low will setting this profile
# SETTING INIT PROFILE
BATTERY_PROFILE=1           # On battery will select this profile
PLUGIN_PROFILE=3            # On plugin adapter will select this profile
# UNDERVOLT
# Setting to undervolt CPU -> Colddown (mha)
# Config this must carefully, can damage your cpu ( set to 0 if you want to bypass )
CPU_VOLT="0"
GPU_VOLT="0"
CPU_CACHE_VOLT="0"
######### END OF CONFIG #########