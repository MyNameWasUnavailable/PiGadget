# PZeroGadget

I was looking for a project that allowed me to setup a PI Zero as a USB keyboard with Rndis networking.

I wasnt able to find anything that was exactly what I wanted, however there were a few that were close!

This project is heavily based on the work of others, and I do not claim this to be of my own creation, I simply re-packaged and picked through, and used the pieces of the projects I needed.

Projects I have based this on, include:

https://github.com/gilyes/pi-shutdown

https://github.com/mame82/P4wnP1

I have been testing this on Raspbian Jessie, I wasnt able to reliably get things to work on Stretch, however I have not had the time to look at why.  Internet connectivity is required during the installation, and it is best if this is done via wifi, and not using g_ether, as the install script doesnt take this into account

to install:

1: cd /home/pi

2: git clone https://github.com/MyNameWasUnavailable/PiGadget.git

3: cd PiGadget

4: sudo chmod +x install.sh

5: sudo ./install.sh

