#!/bin/bash
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