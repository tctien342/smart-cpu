#! /bin/bash
#Clean
echo "Script written by saintno@hackintoshvn"
echo "Begin cleaning..."
TMP="$(launchctl unload -w ~/Library/LaunchAgents/com.saintno.autovoltage.plist &>/dev/null)"
sudo rm -f ~/Library/LaunchAgents/com.saintno.autovoltage.plist
sudo rm -r -f /Library/Application\ Support/VoltageShift

#Warning
echo "<> Before installing."
echo "<> Please set your config in auto.sh and tested it by running 'bash auto.sh'."
echo "<> Testing it about 30min with hard work, if everthing stable then you should be fine to install it."
read -p "<> Press any key to continute, Ctrl + C to cancel..."

#Install
echo "<> Installing..."
sudo cp ./com.saintno.autovoltage.plist ~/Library/LaunchAgents/
sudo chown  root:wheel ~/Library/LaunchAgents/com.saintno.autovoltage.plist
sudo mkdir -p /Library/Application\ Support/VoltageShift/
sudo cp  -R ./VoltageShift.kext /Library/Application\ Support/VoltageShift/
sudo cp  ./voltageshift /Library/Application\ Support/VoltageShift/
sudo cp  ./auto.sh /Library/Application\ Support/VoltageShift/
sudo chown  -R root:wheel /Library/Application\ Support/VoltageShift/VoltageShift.kext
sudo chown  root:wheel /Library/Application\ Support/VoltageShift/voltageshift
sudo chown  root:wheel /Library/Application\ Support/VoltageShift/auto.sh
sudo chmod 777 /Library/Application\ Support/VoltageShift/auto.sh
launchctl load -w ~/Library/LaunchAgents/com.saintno.autovoltage.plist
echo "<> Using 'bash uninstall.sh' to uninstall."
echo "<> Done."