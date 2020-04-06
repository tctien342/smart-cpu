# Try config before use
echo "<> Running try mode..."
sudo rm -f ./src/config.sh
cp ./config.sh ./src
cd ./src
bash ./auto.sh