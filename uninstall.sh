#! /bin/bash
#Clean
TMP="$(launchctl unload -w ~/Library/LaunchAgents/com.saintno.autovoltage.plist &>/dev/null)"
TMP="$(sudo launchctl unload -w ~/Library/LaunchAgents/com.saintno.autovoltage.plist &>/dev/null)"
TMP="$(launchctl unload -w ~/Library/LaunchAgents/com.saintno.notifier.plist &>/dev/null)"
sudo rm -f ~/Library/LaunchAgents/com.saintno.autovoltage.plist
sudo rm -f ~/Library/LaunchAgents/com.saintno.notifier.plist
sudo rm -r -f /Library/Application\ Support/VoltageShift
sudo rm -f /usr/local/bin/cprofile
echo "<> Uninstall success"
