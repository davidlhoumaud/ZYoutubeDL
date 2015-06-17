all : install
install :
	sudo cp zyoutubedl.sh /usr/bin/zyoutubedl
	sudo cp zyoutubedl.desktop /usr/share/applications/zyoutubedl.desktop
	sudo chmod 755 /usr/bin/zyoutubedl
	sudo chmod 755 /usr/share/applications/zyoutubedl.desktop
uninstall :
	sudo rm -f /usr/bin/zyoutubedl
	sudo rm -f /usr/share/applications/zyoutubedl.desktop
