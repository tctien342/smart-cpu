#! /bin/bash
#Clean
TMP="$(launchctl unload -w ~/Library/LaunchAgents/com.saintno.autovoltage.plist &>/dev/null)"
sudo rm -f ~/Library/LaunchAgents/com.saintno.autovoltage.plist
sudo rm -r -f /Library/Application\ Support/VoltageShift
echo "<> Uninstall success"