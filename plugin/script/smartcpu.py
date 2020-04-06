#!/usr/bin/python3
import sys
profile = -1
battery = False
config = []
setting = []
notification = True
auto_shut = True

def get_status(bool):
    """
        Return check if True
    """
    if bool:
        return "✓"
    else:
        return "..."

def get_now_run(pos):
    """
        Return check for current profile
    """
    return get_status(int(profile) == pos)

# Getting profile position
with open("/Users/Shared/.smartcpu/profile", "r") as input:
    lines = input.readlines()
    for line in lines:
        profile = line

# Getting current config
with open("/Users/Shared/.smartcpu/config", "r") as input:
    lines = input.readlines()
    for line in lines:
        config.append(line)
        
# Getting current config
try:
    with open("/Users/Shared/.smartcpu/notification", "r") as input:
        lines = input.readlines()
        if lines[0].rstrip() == "1":
            notification = True
        else:
            notification = False
except IOError:
    print(":warning: Please install script to use plugin! | color=#ff0000")
    print("---")
    notification = False

# Getting auto shut down conf
try:
    with open("/Users/Shared/.smartcpu/auto_shut", "r") as input:
        lines = input.readlines()
        if lines[0].rstrip() == "1":
            auto_shut = True
        else:
            auto_shut = False
except IOError:
    auto_shut = False
    
# Getting current setting
with open("/Users/Shared/.smartcpu/setting", "r") as input:
    lines = input.readlines()
    for idx,val in enumerate(lines):
        setArray = val.split(" ")
        setConf = {}
        setConf["S"] = setArray[0]
        setConf["L"] = setArray[1]
        setConf["T"] = setArray[2].rstrip()
        setting.append(setConf)

# Getting current battery status
with open("/Users/Shared/.smartcpu/battery", "r") as input:
    lines = input.readlines()
    if str(lines[0]).rstrip() == "true":
        battery = True
    else:
        battery = False

# Print current config
print("Power management info")
print("POWER LONG \t", str(config[0]).rstrip(), "W | color=#ff0000")
print("POWER SHORT \t", str(config[1]).rstrip(), "W | color=#ff0000")
if int(config[2]) == 1:
    print("TURBO BOOST \t ENABLED | color=#ffff00")
else:
    print("TURBO BOOST \t DISABLED | color=#ffff00")
print("---")
print("Voltage offset info")
print("CPU VOLTAGE \t", str(setting[5]["S"]).rstrip(), "mv | color=#ff0000")
print("CPU CACHE   \t", str(setting[5]["T"]).rstrip(), "mv | color=#00ff00")
print("GPU VOLTAGE \t", str(setting[5]["L"]).rstrip(), "mv | color=#0000ff")
# Print select profile
print("---")
print("Select power profile")
if battery:
    print(get_now_run(0),
          "\tExtra Battery :warning: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=0 terminal=false refresh=2")
    print("----")
    print("--Config values: S" + setting[0]["S"] ,"L" + setting[0]["L"], "T" + setting[0]["T"], "| color=#FC74B3")
    print("--Extra profile for battery, will hold processor| color=#6FC1FF size=12")
    print("--run on lowest power for save more battery.| color=#6FC1FF size=12")
    print(get_now_run(1),
          "\tBattery :battery: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=1 terminal=false refresh=2")
    print("----")
    print("--Config values: S" + setting[1]["S"] ,"L" + setting[1]["L"], "T" + setting[1]["T"], "| color=#FC74B3")
    print("--Default setting for battery mode.| color=#6FC1FF size=12")
else:
    print(get_now_run(2),
          "\tBalance :snowflake: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=2 terminal=false refresh=2")
    print("--Config values: S" + setting[2]["S"] ,"L" + setting[2]["L"], "T" + setting[2]["T"], "| color=#FC74B3")
    print("--Cool profile for cpu, this will keep processor| color=#6FC1FF size=12")
    print("--don't suck too much power for less heat, better| color=#6FC1FF size=12")
    print("--for watching movie and web developer.| color=#6FC1FF size=12")
    print(get_now_run(3),
          "\tPerformance :muscle: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=3 terminal=false refresh=2")
    print("--Config values: S" + setting[3]["S"] ,"L" + setting[3]["L"], "T" + setting[3]["T"], "| color=#FC74B3")
    print("--Performance profile for cpu, allow cpu run| color=#6FC1FF size=12")
    print("--on higher power but don't let fan too noise,| color=#6FC1FF size=12")
    print("--for game and mobile app developer.| color=#6FC1FF size=12")
    print(get_now_run(4),
          "\tExtra Performance :fire: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=4 terminal=false refresh=2")
    print("--Config values: S" + setting[4]["S"] ,"L" + setting[4]["L"], "T" + setting[4]["T"], "| color=#FC74B3")
    print("--Maxout processor performance, release the beast,| color=#6FC1FF size=12")
    print("--allow process suck more power for heavy job.| color=#6FC1FF size=12")
    print("--Mining bitcon ? =)).| color=#6FC1FF size=12")
print("---")
print("Extra config")
if (notification): 
    print(get_status(notification),"\tToggle notification | bash=/bin/bash param1=/usr/local/bin/cprofile param2=-1 param3=0 terminal=false refresh=2")
else:
    print(get_status(notification),"\tToggle notification | bash=/bin/bash param1=/usr/local/bin/cprofile param2=-1 param3=1 terminal=false refresh=2")

if (auto_shut): 
    print(get_status(auto_shut),"\tToggle auto shutdown | bash=/bin/bash param1=/usr/local/bin/cprofile param2=-1 param3=-1 param4=0 terminal=false refresh=2")
else:
    print(get_status(auto_shut),"\tToggle auto shutdown | bash=/bin/bash param1=/usr/local/bin/cprofile param2=-1 param3=-1 param4=1 terminal=false refresh=2")
print("--Auto shutdown system when battery is below 5% percent,| color=#6FC1FF size=12")
print("--you will have 1min before shutting down.| color=#6FC1FF size=12")
