#!/bin/bash
# Install script for pizero HID  / lan device
#Heavily based on the following projects, taking the parts that were usefull to me and consolodating it into my own:
#https://github.com/gilyes/pi-shutdown
#https://github.com/mame82/P4wnP1
#Blah

echo "Updating system before we start"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install python3-gpiozero
# create systemd service unit for pigadget startup
if [ ! -f /etc/systemd/system/pigadget.service ]; then
        echo "Injecting Pigadget startup script..."
        cat <<- EOF | sudo tee /etc/systemd/system/pigadget.service > /dev/null
                [Unit]
                Description=USB Gadget Service
                #After=systemd-modules-load.service
                After=local-fs.target
                DefaultDependencies=no
                Before=sysinit.target

                [Service]
                #Type=oneshot
                Type=forking
                RemainAfterExit=yes
                ExecStart=/bin/bash /home/pi/PiGadget/usb/init_usb.sh
                StandardOutput=journal+console
                StandardError=journal+console

                [Install]
                #WantedBy=multi-user.target
                WantedBy=sysinit.target
EOF
fi

if [ ! -f /etc/systemd/system/pishutdown.service ]; then
        echo "Injecting Pishutdown startup script..."
        cat <<- EOF | sudo tee /etc/systemd/system/pishutdown.service > /dev/null
            [Service]
                ExecStart=/usr/bin/python /home/pi/PiGadget/shutdown/pishutdown.py
                WorkingDirectory=/home/pi/PiGadget/shutdown/
                Restart=always
                StandardOutput=syslog
                StandardError=syslog
                SyslogIdentifier=pishutdown
                User=root
                Group=root

            [Install]
                WantedBy=multi-user.target
EOF
fi

#Enable services
echo "Enable Services"
sudo chmod +x /home/pi/PiGadget/usb/init_usb.sh
sudo chmod +x /home/pi/PiGadget/shutdown/pishutdown.py
sudo systemctl enable pishutdown.service
sudo systemctl enable pigadget.service

echo "Enable overlay filesystem for USB gadget suport..."
sudo sed -n -i -e '/^dtoverlay=/!p' -e '$adtoverlay=dwc2' /boot/config.txt

# add libcomposite to /etc/modules
echo "Enable kernel module for USB Composite Device emulation..."
if [ ! -f /tmp/modules ]; then sudo touch /etc/modules; fi
sudo sed -n -i -e '/^libcomposite/!p' -e '$alibcomposite' /etc/modules

echo "Installing kernel update, which hopefully makes USB gadgets work again"
# still needed on current stretch releas, kernel 4.9.41+ ships still
# with broken HID gadget module (installing still needs a cup of coffee)
# Note:  last working Jessie version was the one with kernel 4.4.50+
#        stretch kernel known working is 4.9.45+ (only available via update right now)
sudo rpi-update

echo "===================================================================================="
echo "Should be good to go"
echo ""
echo "Please reboot now!"
echo "===================================================================================="




