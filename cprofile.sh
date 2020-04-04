#! /bin/bash
mkdir -p /Users/Shared/.smartcpu
if [ -z "$1" ] || [ $(($1)) -eq -1 ];then
    echo "<i> Bypass profiles"
else
    echo "<p> Setting profile..."
    echo "$1" >"/Users/Shared/.smartcpu/profile"
fi
if [ -z "$2" ] || [ $(($2)) -eq -1 ];then
    echo "<i> Bypass notifier"
else
    echo "<p> Setting notifier..."
    echo "$2" >"/Users/Shared/.smartcpu/notification"
fi
if [ -z "$3" ] || [ $(($3)) -eq -1 ];then
    echo "<i> Bypass notifier"
else
    echo "<p> Setting auto shut down..."
    echo "$3" >"/Users/Shared/.smartcpu/auto_shut"
fi
