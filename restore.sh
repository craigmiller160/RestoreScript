#!/bin/sh
# System restore script

MEDIA="MyPassport"
BACKUP="Seagate Expansion Drive"
EXTERNAL_PLEX="/media/craig/Seagate Expansion Drive/Backup/Plex Media Server"
INTERNAL_PLEX="/var/lib/plexmediaserver/Library/Application Support/"

echo "Craig-PC Restore Script"
echo "This script will upgrade your installation and install the following applications on this system:"
echo "   Android Studio IDE"
echo "   Chrome Browser"
echo "   Git VCS"
echo "   IntelliJ IDE"
echo "   MySQL Server"
echo "   MySQL Workbench"
echo "   Plex Media Center"
echo "   Skype"
echo "   Tixati"
echo "   Unity Tweak Tool"
echo "   VLC Media Player"
echo "   7zip"

echo "This process will take time. There will be prompts for user input along the way. You will need to be present until it is complete."

echo "Do you want to begin the system restore process? (y/n): "
read START

if [ "$START" != "y" ]; then
	echo "Cancelling restoration"
	exit 0
fi

# Start the superuser shell
sudo -i

# Additional repoistories
add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" -y
add-apt-repository ppa:webupd8team/sublime-text-3 -y

# Update the apt-get tool's repository data
apt-get update -y
apt-get upgrade -y

# Install basic apps
apt-get install chromium-browser -y
apt-get install vlc -y
apt-get install skype -y
apt-get install p7zip -y
apt-get install sublime-text-installer -y

# MySQL Setup
apt-get install mysql-server -y
apt-get install mysql-workbench -y

# Git Setup
apt-get install git -y
git config --global user.email "craigmiller160@gmail.com"
git config --global user.name "craigmiller160"

# Ubuntu Theming
apt-get install unity-tweak-tool

# Tixati doesn't get installed via apt-get, it is retrieved from the website
wget www.tixati.com/download/tixati_1.96-1_amd64.deb
dpkg -i tixati_1.96-1_amd64.deb -y
rm tixati_1.96-1_amd64.deb

# Plex Media Server stuff
apt-get install avahi-daemon -y
wget "https://downloads.plex.tv/plex-media-server/0.9.15.6.1714-7be11e1/plexmediaserver_0.9.15.6.1714-7be11e1_amd64.deb"
dpkg -i plexmediaserver_0.9.15.6.1714-7be11e1_amd64.deb -y
service plexmediaserver stop
rm -rf "$INTERNAL_PLEX/Plex Media Server/"
cp -r "$EXTERNAL_PLEX" "$INTERNAL_PLEX"
chown -R "$INTERNAL_PLEX/Plex Media Server/"
service plexmediaserver start
rm plexmediaserver_0.9.15.6.1714-7be11e1_amd64.deb

# Finishing Operation
echo "Success! All packages installed."
echo "To complete the restoration process, your system will need to be restarted."
echo "Restart now? (y/n): "
read RESTART

if [ RESTART == "y" ]; then
	sudo shutdown -r now
fi 

exit 0
