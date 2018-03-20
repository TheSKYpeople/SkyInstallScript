# SkyInstallScript
Automatic installation script for Skyminers / Skycoin node

We wanted to make the process of setting up a fully operational Skycoin Miner as easy as possible for everyone. To do so we developed an installation script that will do the complex process with ease and fully automated. 

We also included auto start scripts to keep your miners operational after a reboot or a shutdown. They are also automatically installed with the script. The installation script needs only to be executed on one board and it logins in to the other boards via SSH itself to install them, too. 

After you finished the hardware assembly using the following tutorial you are good to start with the software part using this tutorial.
Hardware tutorial Link:  https://downloads.skycoin.net/skywire/Skywire_Miner_Assembly_Manual_2_1.pdf


# Preparations for Installation

# Installation

## Downloads

### Etcher - (Software to Flash SD Cards) 
Depending on what OS you are using on your Workstation (the computer you use in your daily life), you need a special software (Etcher) to flash the image of the operation system for the Orange PI boards of your Skyminer to the SD Cards (shipped with your Skyminer).
Please download for
Windows 64bit 
https://github.com/resin-io/etcher/releases/download/v1.3.1/Etcher-Setup-1.3.1-x64.exe
Windows 32bit 
https://github.com/resin-io/etcher/releases/download/v1.3.1/Etcher-Portable-1.3.1-x86.exe
MacOS
https://github.com/resin-io/etcher/releases/download/v1.3.1/Etcher-1.3.1.dmg
Linux 64bit
https://github.com/resin-io/etcher/releases/download/v1.3.1/etcher-1.3.1-linux-x86_64.zip
Linux 32bit
https://github.com/resin-io/etcher/releases/download/v1.3.1/etcher-1.3.1-linux-i386.zip

### Armbian - (Operation System for Orange PI’s) 
All other tutorials we came across used the full desktop version (with GUI) of Armbian. We would highly recommend to only use the light/server version since a GUI setup always comes with a few downsides. First GUI needs more computing resources which can be used for the miner itself and second a desktop version comes with a lot of bloatware which increases the chances of a security breach. Our tutorial although is that simple and step by step that you will face no issues installing the server version.  
Please download 
ARMBIAN for Orange PI Prime server version (Ubuntu based)
https://dl.armbian.com/orangepiprime/Ubuntu_xenial_next.7z


### SSH Client PuTTY/Cyberduck  (for remote control) 
PuTTY for Windows and Cyberduck for MacOS is used to remote control your Orange PI’s from your workstation. It makes it possible to copy & paste the commands given in this tutorial easily into the remote machine (the Orange PI’s). Putty is only necessary if you are working on a Windows and Cyberduck only for Mac workstations. All Linux workstation have an SSH client natively incorporated inside the terminal (if not it can be easily installed within the terminal). Later in this tutorial we will also explain how to connect to the Orange PI’s using both Putty and Linux SSH.
Please download:
PuTTY for Windows 64bit  
https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi

PuTTY for Windows 32bit  
https://the.earth.li/~sgtatham/putty/latest/w32/putty-0.70-installer.msi

Cyberduck for MacOS  
https://update.cyberduck.io/Cyberduck-6.4.1.27633.zip


### Extractor for 7zip files (needed to unzip Armbian)
Most likely you already have an extractor capable of handling 7zip archives installed on your workstation. In that case you can skip this step.
Please download:
7zip for Windows 64bit  
http://www.7-zip.org/a/7z1801-x64.exe
7zip for Windows 32bit  
http://www.7-zip.org/a/7z1801.exe
Keka for MacOS  
http://download.kekaosx.com/
Linux Debian / Ubuntu based
sudo apt-get update -yqq
sudo apt-get install -yqq p7zip-full
Linux CentOS / Fedora based
sudo yum install -y -q epel-release
sudo rpm -U --quiet http://mirrors.kernel.org/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
sudo yum repolist
sudo yum install -y -q p7zip p7zip-plugins

The download part is now finished!
Let’s install the just downloaded software on your workstation (but not Armbian of course 😉). We think that process is straight forward, and you won’t need any further instructions for that. In case you do - feel free to contact us!

## Flashing Orange PI SD Cards
Alright! Now that your environment is perfectly prepared let’s get some stuff done. 
First, we start with flashing all 8 SD cards with Armbian using Etcher. Before we can do that, we need to unzip the Armbian download file.
By doing the steps mentioned above we are going to make Armbian bootable on the Orange PI boards. If you are used to installing an operation system like Windows or Linux this step will come to some surprise for you. Etcher does basically the entire installation process without any user input. You just plug the SD cards into your Orange PI’s and as soon as you switch the power supply on the will boot into the ready to use OS right away.
Ready? Let’s go 😊
1.	Unzip the downloaded Armbian 7zip archive using 7zip. 
To do so right click on the archive, select 7-zip and then unzip to... 

