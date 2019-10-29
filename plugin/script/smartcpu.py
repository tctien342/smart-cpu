#!/usr/bin/python3
import sys
profile = -1
config = []


def get_now_run(pos):
    """
        Return check for current profile
    """
    if int(profile) == pos:
        return "✓"
    else:
        return ">"

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

# Print current config
print("POWER LONG:", str(config[0]).rstrip(), "W")
print("POWER SHORT:", str(config[1]).rstrip(), "W")

if int(config[2]) == 1:
    print("TURBO: ENABLED")
else:
    print("TURBO: DISABLED")

# Print select profile
print("---")
print(get_now_run(0),
      "Extra Battery :zap: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=0 terminal=false refresh=2")
print(get_now_run(1),
      "Battery :battery: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=1 terminal=false refresh=2")
print(get_now_run(2),
      "Normal :hourglass: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=2 terminal=false refresh=2")
print(get_now_run(3),
      "Performance :muscle: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=3 terminal=false refresh=2")
print(get_now_run(4),
      "Extra Performance :fire: | bash=/bin/bash param1=/usr/local/bin/cprofile param2=4 terminal=false refresh=2")
