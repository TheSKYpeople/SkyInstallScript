#!/bin/bash
 
#######################################################################################################################################################################
#######################################################################################################################################################################
##### SKYMINER (SKYCOIN) ORANGE PI AUTO INSTALL SCRIPT
##### This script automatically installs the full Skycoin and Skywire software including all dependencies with one push of a button on all OrangePI boards.
##### To run this script type "sh SkyInstallScript.sh" into a terminal and hit enter! 
##### For more detailed instructions please consult our tutorial.
##### For further assistence feel free to contact us! 
#######################################################################################################################################################################
##### Version:		1.0  - Get the newest version at https://github.com/TheSKYpeople/SkyInstallScript
#######################################################################################################################################################################
##### Team:			       The SKYpeople (Email: TheSKYpeople@protonmail.com - Telegram: @TheSKYpeople)
##### Licence:		     GNU General Public License v3.0
##### Donations:	    Skycoin      zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB
#####				            Ethereum     0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0
#####				            Bitcoin 	    1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ
#######################################################################################################################################################################
#######################################################################################################################################################################

#######################################################################################################################################################################
#######################################################################################################################################################################
 
 

#######################################################################################################################################################################
#######################################################################################################################################################################
###### DON'T CHANGE ANYTHING BELOW THIS LINE (IF YOU DON'T KNOW WHAT YOU ARE DOING)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#######################################################################################################################################################################
#######################################################################################################################################################################
 
 
##### ASK ROOT PASSWORD FOR ORANGEPI BOARDS (must be identical on all board to autoinstall board 2-8 using ssh)
echo "In order to install the OrangePI boards 2-8 automatically, we need to login via SSH to run the install routine. Please make sure the root password is the same on all boards!"
# read password twice
read -s -p "Please enter root password: " RootPassword
echo 
read -s -p "Please enter root password (again): " RootPassword2

# check if passwords match and if not ask again
while [ "$RootPassword" != "$RootPassword2" ];
do
    echo 
    echo "Passwords do not match! Please try again."
    read -s -p "Password: " RootPassword
    echo
    read -s -p "Password (again): " RootPassword2
done


 
##### UPDATING RESPOSITORY & UPGRADING OS
echo "Updating respository and perfoming OS upgrade right now..."
sudo apt-get update && sudo apt-get upgrade -y
echo "Repository Update and OS Upgrade succesfully done!"
 
 
##### INSTALL DEPENDECIES FOR GO
echo "Installing GO dependencies right now..."
sudo apt-get install -y curl git mercurial make binutils gcc bzr bison libgmp3-dev screen build-essential
echo "GO ependencies succesfully installed!"
 
 
##### INSTALL GO LIBRARY
echo "Installing GO right now..."

###### Downloading GO source from Google servers using CURL
sudo curl -L https://dl.google.com/go/go1.9.2.linux-arm64.tar.gz -o go1.9.2.linux-arm64.tar.gz

###### Unzip the compressed GO source files
sudo tar -xvf go1.9.2.linux-arm64.tar.gz

###### Remove the downloaded compressed file (not needed anylonger!)
sudo rm go1.9.2.linux-arm64.tar.gz

###### Move GO folder to it's destination directory
sudo mv go /usr/local

###### Configure go enviroment variable
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile

###### Reload the paths
. ~/.profile

###### Create GO directories
mkdir -p $HOME/go
mkdir -p $HOME/go/bin
mkdir -p $HOME/go/src
mkdir -p $HOME/go/pkg

###### Move GO folder
sudo mv go /usr/local/go

###### Create GO links
sudo ln -s /usr/local/go/bin/go /usr/local/bin/go
sudo ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc
sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

###### Return to root folder
cd ~

###### Configure $GOPATH variables
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export GOBIN=$GOPATH/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$GOBIN' >> ~/.bashrc

###### Reload GO paths
. ~/.bashrc
echo "GO succesfully installed!"
 

 
##### INSTALL SKYCOIN
echo "Installing Skycoin right now..."
###### Obtain Skycoin source files from Github using GO
go get github.com/skycoin/skycoin/...
echo "Skycoin succesfully installed!"
cd $GOPATH/src/github.com/skycoin/skycoin


###### Launching Skycoin in the background
echo "Launching Skycoin Now"
make run > /dev/null 2>&1 &
sleep 10
echo "Skycoin is now running the wallet is synchronizing in the background"
 
 
##### INSTALL SKYWIRE
echo "Installing Skywire right now..."
###### Change the path for download
cd $GOPATH/src/github.com/skycoin
###### Obtain Skywire source files from Github using GIT
git clone https://github.com/skycoin/skywire.git
###### Chaning into installation path
cd $GOPATH/src/github.com/skycoin/skywire/cmd
###### Run Skywire installation
go install ./...
echo "Skywire succesfully installed!"


##### Now Lauching Skywire
echo "Now lauching Skywire"
cd $GOPATH/bin
./manager -web-dir ${GOPATH}/src/github.com/skycoin/skywire/static/skywire-manager > /dev/null 2>&1 &
echo "Skywire is now running in the background. You can now access the Skywire Manager via the web browser" 
sleep 5


##### START SKYWIRE MONITOR
###### Change into installation path
cd $GOPATH/bin
###### Starts Skywire Monitor service for the first time / after that command web interface of Monitor works
###### This line is to start the monitor on the master node (OrangePI 1) only / Other Orange PIs requiere a different line with the master nodes IP!!!
./node -connect-manager -manager-address :5998 -manager-web :8000 -discovery-address messenger.skycoin.net:5999 -address :5000 -web-port :6001 &> /dev/null 2>&1 &
echo "Skywire monitor started." 
 


##### AUTOSTART SCRIPTS / STOP SCRIPTS
###### Download autostart / stop scripts
echo "Downloading autostart scripts from TheSKYpeople Github" 
cd ~
wget https://raw.githubusercontent.com/TheSKYpeople/SkyInstallScript/master/ServiceStartSkycoinWallet.sh
wget https://raw.githubusercontent.com/TheSKYpeople/SkyInstallScript/master/ServiceStartSkywirePrimary.sh
###### This is only be downloaded in case you need to stop Skywire with a script one day (it has no function in this script)
wget https://raw.githubusercontent.com/TheSKYpeople/SkyInstallScript/master/ServiceStopSkywire.sh

###### Move script to init.d directory 
sudo mv ServiceStartSkycoinWallet.sh /etc/init.d/
sudo mv ServiceStartSkywirePrimary.sh /etc/init.d/

###### Invoke update-rc.d
sudo update-rc.d ServiceStartSkycoinWallet.sh defaults
sudo update-rc.d ServiceStartSkywirePrimary.sh defaults



##### AUTO INSTALL SKYMINER SOFTWARE ON ORANGEPI'S 2-8 VIA SSH
###### Download install script for secondary boards (OrangePI's 2-8)
echo "Installation finished on OrangePI 1 (Master Board)."
echo "Now automatically installing OrangePI 2-8 using SSH"
echo "Please make sure that all OrangePIs are powered on!!!"
cd ~
wget https://raw.githubusercontent.com/TheSKYpeople/SkyInstallScript/master/SkyInstallScriptSecondary.sh

###### Install sshpass in order to login to OrangePI boards 2-8 using ssh
sudo apt-get install sshpass

###### Scan and add keys to trusted list
ssh-keyscan -H 192.168.0.102 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.103 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.104 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.105 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.106 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.107 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.108 >> ~/.ssh/known_hosts

###### Connect to OrangePI 2 and run installation
sshpass -p RootPassword ssh root@192.168.0.102 'bash -s' < ~/SkyInstallScriptSecondary.sh && exit
###### Connect to OrangePI 3 and run installation
sshpass -p RootPassword ssh root@192.168.0.103 'bash -s' < ~/SkyInstallScriptSecondary.sh && exit
###### Connect to OrangePI 4 and run installation
sshpass -p RootPassword ssh root@192.168.0.104 'bash -s' < ~/SkyInstallScriptSecondary.sh && exit
###### Connect to OrangePI 5 and run installation
sshpass -p RootPassword ssh root@192.168.0.105 'bash -s' < ~/SkyInstallScriptSecondary.sh && exit
###### Connect to OrangePI 6 and run installation
sshpass -p RootPassword ssh root@192.168.0.106 'bash -s' < ~/SkyInstallScriptSecondary.sh && exit
###### Connect to OrangePI 7 and run installation
sshpass -p RootPassword ssh root@192.168.0.107 'bash -s' < ~/SkyInstallScriptSecondary.sh && exit
###### Connect to OrangePI 8 and run installation
sshpass -p RootPassword ssh root@192.168.0.108 'bash -s' < ~/SkyInstallScriptSecondary.sh && exit

###### Clear root password variable
unset RootPassword

##### SUCCESSFUL INSTALLATION NOTIFICATION
echo "Congratulation your Skyminer is now fully installed!"
echo "Happy earning!"
echo "Please consider a small donation if you like our script!"
echo "SKYCOIN: zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB"
echo "BITCOIN: 0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0"
echo "ETHEREUM: 1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ"



