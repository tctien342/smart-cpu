# SmartCPU
+ Auto change power usage of cpu
+ This script may cause panic, dead cpu due to your config.
+ In care your system is not stable, please run uninstall and reboot then find an better config.

# Info
    + Ver 1.5
    + Init auto script for plugin and battery mode
    + This script will controll your cpu power such as:
        + Long term power
        + Short term power
        + Turbo
        + Undervolt
    And change it when in battery and in plugin mode
    + You can read more info at here: https://github.com/sicreative/VoltageShift
    + Add 5 profile to be selected
# Changelog
## Ver 1.5
    + Fix value not applied
    + Add more profile
    + Add select profile through Bitbar
![Alt text](menu.png)

# Installation
    + Pull source code
    + Changing your config at auto.sh
    + Testing it by using command "bash auto.sh"
    + Hard work for about 30min for checking stable state
    + When it stable run "bash install.sh" to make it run at boot
    + Install Bitbar at https://github.com/matryer/bitbar
    + Select plugin as bitbar's plugin folder or copy all file in plugin to bitbar's plugin folder
    + To remove, use "bash uninstall.sh".

# Thanks
    @sicreative for his cpu's kext