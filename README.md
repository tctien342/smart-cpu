# SmartCPU
+ Auto change power usage of cpu
+ This script may cause panic, dead cpu due to your config.
+ In care your system is not stable, please run uninstall and reboot then find an better config.

# Info
+ Ver 2.0
+ Init auto script for plug-in adapter and battery mode
+ This script will control your cpu power such as:
    + Long term power
    + Short term power
    + Turbo
    + Undervolt
+ Auto switch profile on low battery
+ Auto shutdown on critical battery
+ Base on VoltageShift kext by @sicreative
    + You can read more info at here: https://github.com/sicreative/VoltageShift
+ Add 5 profile to be selected
    + 2 Profile working on battery mode
    + 3 Profile on plug-in mode

# Changelog
## Ver 2.3
+ Optimize code, do not change value on sleeping
+ Allow auto shutdown when low battery on sleeping
+ Config now store on config.sh file
+ Add voltage status to plugin
+ Add CPU cache offset

## Ver 2.0
+ Add auto change profile on low battery
+ Add auto shutdown on critical battery
+ Toggle on/off notification
+ Toggle on/off auto shutdown
+ Redesign bitbar plugin

![Alt text](menu.png)

## Ver 1.6
+ Fix auto load value on reboot

## Ver 1.6
+ Fix auto load value on reboot
    
## Ver 1.5
+ Fix value not applied
+ Add more profile
+ Add select profile through Bitbar

# Installation
    + Pull source code
    + Changing your cpu's value at auto.sh file
    + Testing it by using command "bash auto.sh"
    + Hard work for about 30min for checking stable state
    + When it stable run "bash install.sh" to make it run at boot
    + Install Bitbar at https://github.com/matryer/bitbar
    + Select plugin as bitbar's plugin folder or copy all file in plugin to bitbar's plugin folder
    + To remove, use "bash uninstall.sh".

# Thanks
    @sicreative for his cpu's kext