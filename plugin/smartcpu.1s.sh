#!/bin/bash
# <bitbar.title>SmartCPU Script</bitbar.title>
# <bitbar.version>v2.3</bitbar.version>
# <bitbar.author>SaintNo</bitbar.author>
# <bitbar.author.github>tctien342</bitbar.author.github>
# <bitbar.desc>CPU power management for MacOSX.</bitbar.desc>
# <bitbar.image>https://raw.githubusercontent.com/tctien342/smart-cpu/master/menu.png</bitbar.image>
# <bitbar.dependencies>python,bash</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/tctien342/smart-cpu</bitbar.abouturl>

# Get profile name
PROFILE="$(cat /Users/Shared/.smartcpu/profile)"
case $PROFILE in
0)
    PROFILE_NAME="Extra Battery"
    ;;
1)
    PROFILE_NAME="Battery"
    ;;
2)
    PROFILE_NAME="Balance"
    ;;
3)
    PROFILE_NAME="Performance"
    ;;
4)
    PROFILE_NAME="Extra Performance"
    ;;
esac
echo ":zap:"$PROFILE_NAME "| font=Arial"
echo "---"

# Print submenu
python3 $(dirname $0)/script/smartcpu.py