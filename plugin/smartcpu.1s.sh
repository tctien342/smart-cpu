#!/bin/bash
# Get profile name
PROFILE="$(cat /tmp/smartcpu/profile)"
case $PROFILE in
0)
    PROFILE_NAME="Extra Battery"
    ;;
1)
    PROFILE_NAME="Battery"
    ;;
2)
    PROFILE_NAME="Normal"
    ;;
3)
    PROFILE_NAME="Performance"
    ;;
4)
    PROFILE_NAME="Extra Performance"
    ;;
esac
echo $PROFILE_NAME
echo "---"

# Print submenu
python3 $(dirname $0)/script/smartcpu.py