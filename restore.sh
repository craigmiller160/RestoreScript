#!/bin/sh
# System restore script

MEDIA="MyPassport"
BACKUP="Seagate Expansion Drive"

echo "Craig-PC Restore Script"
echo "This script will upgrade your installation and install the following applications on this system:"
echo "   Chrome Browser"
echo "   VLC Media Player"
echo "   Skype"
echo "   Tixati"
echo "   MySQL Server"
echo "   MySQL Workbench"
echo "   IntelliJ IDE"
echo "   Android Studio IDE"
echo "   Git VCS"
echo "   Plex Media Center"

echo "This process will take time. There will be prompts for user input along the way. You will need to be present until it is complete."

echo "Do you want to begin the system restore process? (y/n): "
read START

if [ "$START" != "y" ]; then
	echo "Cancelling restoration"
	exit 0
fi

#############################
### TODO need some way to handle the y/n prompts during execution... or not lol
#############################

# Additional repoistories
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"

# Update the apt-get tool's repository data
sudo apt-get update
sudo apt-get upgrade

# Install basic apps
sudo apt-get install chromium-browser
sudo apt-get install vlc
sudo apt-get install skype

# MySQL Setup
sudo apt-get install mysql-server
sudo apt-get install mysql-workbench

# Git Setup
sudo apt-get install git

# Tixati doesn't get installed via apt-get, it is retrieved from the website
wget www.tixati.com/download/tixati_1.96-1_amd64.deb
sudo dpkg -i tixati_1.96-1_amd64.deb
rm tixati_1.96-1_amd64.deb

echo "Success! All packages installed."
echo "To complete the restoration process, your system will need to be restarted."
echo "Restart now? (y/n): "
read RESTART

if [ RESTART == "y" ]; then
	sudo shutdown -r now
fi 

exit 0
