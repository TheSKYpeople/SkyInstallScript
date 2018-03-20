# SkyInstallScript
Automatic installation script for Skyminers / Skycoin node

We wanted to make the process of setting up a fully operational Skycoin Miner as easy as possible for everyone. To do so we developed an installation script that will do the complex process with ease and fully automated. 

We also included auto start scripts to keep your miners operational after a reboot or a shutdown. They are also automatically installed with the script. The installation script needs only to be executed on one board and it logins in to the other boards via SSH itself to install them, too. 

After you finished the hardware assembly using the following tutorial you are good to start with the software part using this tutorial: https://downloads.skycoin.net/skywire/Skywire_Miner_Assembly_Manual_2_1.pdf


# Preparations for Installation
## Downloads

### Etcher - (Software to Flash SD Cards) 
Depending on what OS you are using on your Workstation (the computer you use in your daily life), you need a special software (Etcher) to flash the image of the operation system for the Orange PI boards of your Skyminer to the SD Cards (shipped with your Skyminer).

Please download for

| Platform	| Download Link | 
| ------------- |:-------------:| 
| Windows 64bit | https://github.com/resin-io/etcher/releases/download/v1.3.1/Etcher-Setup-1.3.1-x64.exe |
| Windows 32bit | https://github.com/resin-io/etcher/releases/download/v1.3.1/Etcher-Portable-1.3.1-x86.exe      |
| MacOS		| https://github.com/resin-io/etcher/releases/download/v1.3.1/Etcher-1.3.1.dmg      		|
| Linux 64bit	| https://github.com/resin-io/etcher/releases/download/v1.3.1/etcher-1.3.1-linux-x86_64.zip    |
| Linux 32bit	| https://github.com/resin-io/etcher/releases/download/v1.3.1/etcher-1.3.1-linux-i386.zip      |

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
2.	As a result, we get a new folder containing the file we going to need to flash the SD card with Etcher. It’s a .iso file. 
3.	Now open Etcher and click on “Select image”.
4.	Select the Armbian .iso image (highlighed in yellow above) and click “Open”. 
5.	Insert the first microSD card into your computers SD Card reader. In most cases you will need an adaptor for that as shown below (SD or USB both work fine). 
6.	Now we need to select the drive of the microSD card. Sometimes the card gets selected automatically when it’s the only one connected to the PC.
Attention! Be careful and select the right drive. If you accidently select a wrong drive you completely erase all its data. 
To prevent this rather unplug all other memory cards, USB sticks and external hard drives first (if possible). 
7.	Perfect now we are good to go. Press the “Flash!” button and lets flash 😊.
8.	When you see the picture above the first card is successfully flashed. If something went south, please feel free to contact as for assistance. 
9.	Now repeat the same with the other 7 microSD cards.
10.	Well done! Let’s take your awesome Skyminer and 4 of the 8 flashed microSD cards and insert the 4 cards to the top row of Orange PI’s. 
You might think now why only 4 and only the top ones? Simple answer we need an HDMI display and a USB keyboard to prepare the operation system (Armbian) for the first start. The bottom raw is simply not accessible with an SD cable. So, we do the next steps on 4 cards and when finished we unplug them and plug them to the bottom row. After that we repeat the same steps with the last 4 microSD’s.

## First Login to Armbian
1.	Connect the Ethernet cables of your miner, internet router and your workstation. If you haven’t it done already, please connect your Skyminer’s router (WAN port) with your internet router using an ethernet cable. Also connect the Orange PI’s to the routers switch, spare one port for the moment (like shown in the picture below) and connect your workstation computer with it to use Putty/SSH client.
2.	Okay now connect a HDMI display (if not available you can use a HDMI TV, too) and a USB keyboard to OrangePI number 1. There is no need for a mouse since wse decided to don’t use the GUI version of Armbian.
3.	Turn on power for OrangePI number 1. Armbian is booting now and after a few seconds you should see a login screen like in the picture below. If something is not working here, please contact us for assistence. 
4.	Login as root with the password 1234. To do so enter “root” press enter and enter “1234” press enter. Linux usually don’t show anything while you type your password. That’s normal just type “1234” and press enter. 
5.	Now you are requiered to change the root password. Select a strong password here with at least 13 digits and one special character. (Use the same password for all other OrangePI’s)
6.	Now we are asked to setup a user and give it a password. Since Armbian is based on Debian/Ubuntu the user can obtain sudo rights. That’s why we need to choose a strong password here, too. But again you can use the same for all 8 OrangePI’s. As username we have choosen “skyminer”, you can choose another one if you want.
7.	Now you are asked a couple of questions about the new user.  But you don’t need to provide them you can just hit enter and confirm with Y + enter at the end.

Full name: <Enter>
Room number: <Enter>
Work phone: <Enter>
Home phone: <Enter>
Other: <Enter>
Is the information correct: Y + <Enter>

8.	Well done! We are logged in as root now. To make the board available for Putty/SSH and to use the webservices like the wallet we need to give it a static IP address. We do this in the next step…
9.	In this last step (on the board it self) we give it an static IP. The router of the Skyminer always has the IP 192.168.0.1 which will also be both the satandard gateway as well as the DNS server for the OrangePI’s. We decided to give the boards the following IP addresses. 
OrangePI 1  192.168.0.101   (Master Board)	
OrangePI 2	192.168.0.102
OrangePI 3	192.168.0.103
OrangePI 4	192.168.0.104
OrangePI 5	192.168.0.105
OrangePI 6 	192.168.0.106
OrangePI 7	192.168.0.107
OrangePI 8	192.168.0.108

Now let us change the IP of the board according to the list above. For the example we use OrangePI 1. 
In the terminal type and press enter afterwards: 
nano /etc/network/interfaces

The network configuration file appears and we are about to make changes inside the green surrounded block (eth0):

Now lets modify the entries like the following:
# Wired adapter #1			stays as it is
allow-hotplug eth0			stays as it is
#no-auto-down eth0 	insert # at the beginning
iface eth0 inet static 	delete dhcp and type static
address 192.168.0.101 	 remove # at the beginning and type IP from the table above (ex:192.168.0.101)
netmask 255.255.255.0	remove # at the beginning
gateway 192.168.0.1 	remove # at the beginning
dns-nameservers 192.168.0.1	remove # and replace 8.8.8.8  8.8.4.4 with 192.168.0.1
Now your screen should look like this:

The changes must be saved to be put into effect.
We do this by pressing Ctrl+x, then type Y and press enter
After that the window automatically closes.
Now you are back in the terminal and we must reboot.
Type reboot now and press enter.
The preconfiguration of the board is finished at this point.
10.	Okay now repeat the same steps in this section (First Login to Armbian) on the other 3 plugged in microSD cards/OrangePI’s. When you are finished unplugged them and insert them into the bottom row of your OrangePI’s, plug in the left 4 microSD’s to the top row and do the same there. After that you are finished with this section.

## Setup Putty (Win) or Keka (MacOS)
In order to be able to connect to the terminal of your OrangePI’s remotly to easily maintain them from your workstation we need to setup Putty. If you using a Linux workstation theres is usally nothing to do since most Linux derivats come with an SSH incorporated in the terminal shell. Mac users gonna need Keka but for the purpose of this tutorial we will only show how to use Putty on Windows. If you have problems installing Keka on Mac or use the SSH client on Linux workstations feel free to contact us for further assistence.
Let’s get started:

1.	Open the Putty file you have downloaded at the beginning of this tutorial. In the window that opens type the IP address of the first OrangePI board into the red circled area and replace the three green “X” with the board you want to connect which would be according to list of IP’s above 192.168.0.101 for OrangePI 1 (the master board). After that click the “Open” button.
 
2.	The following security alert is normal and can be easily ignored. Since you created the certificate yourself and we think you are trusting your self 😉. Just click on “Yes”.

3.	You now have a remote terminal shell on your OrangePI and all commands you run will be run on the OrangePI not on your local machine. 

4.	You need to login to the OrangePI with your user and password. Type “root” when asked “Login as” and when you asked for the password type the one you have choosen when you first started the OrangePI. Be careful it’s the root password not the user password.

5.	Congratulations now you can fully control the OrangePI from your workstation. We are finsihed here and you can move to the next step.

# Installation
1.	Download the Install Script from our Github account. In the terminal type or copy paste the following command:

```
cd && wget https://raw.githubusercontent.com/TheSKYpeople/SkyInstallScript/master/SkyInstallScript.sh
```

Alright lets do some magic. Run the script! In the terminal shell type or copy paste the following command:

```
sh ~/SkyInstallScript.sh
```

2.	You will be asked for the root password you used for all boards. This is needed to automatically login to the OrangePI boards 2-8 and also install the software there automatically. Everyting is now done automatically you just need to wait a couple of minutes. You will be informed as soon the installation is finished.

3.	CONGRATULATIONS!!! Your Skyminer is now fully installed!

