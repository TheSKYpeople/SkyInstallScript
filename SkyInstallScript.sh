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
read -sp "Please enter root password: " RootPassword
echo
read -sp "Please enter root password (again): " RootPassword2

# check if passwords match and if not ask again
while [ "$RootPassword" != "$RootPassword2" ];
do
    echo 
    echo "Passwords do not match! Please try again."
    read -sp "Password: " RootPassword
    echo
    read -sp "Password (again): " RootPassword2
done
##### This must be there so terminal creates a new line after password entry!!!
echo


 
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
echo "You can now open the monitor in your browser: http://192.168.0.101:8000"
sleep 10



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
echo "Installation finished on OrangePI 1 (Master Board)."
echo "Now automatically installing OrangePI 2-8 using SSH"
echo "Please make sure that all OrangePIs are powered on!!!"

echo "We are now going to check if all the boards are up and reachable"
is_alive_ping()
{
  ping -q -c2  $1 > /dev/null
  if [ $? -eq 0 ]; then
        echo "OrangePI with IP: $i is up."
  else
        echo "We detected that at least one OrangePI is down:"
        echo "OrangePI with IP: $i is DOWN (Please start or reboot!)."
        read -p "Do you want to install Skywire on OrangePI $i (y/n)?" Continue

                while [ $Continue != n ] && [ $Continue != y ];
                do echo 'Please answer with y or n'
                read -p "Do you want to install Skywire on OrangePI $i (y/n)? If y (yes) please make sure it is connected via ethernet and turned on in" Continue
                done

                if [ $Continue = y ]; then
                        echo "Continuing the installation proccess......"
                        ping -q -c2 $i > /dev/null
                                if [ $? -ne 0 ]; then
                                echo "OrangePI $i is still not reachable. You can choose not to install on this board for now"
                                read -p "Do you want to install Skywire on OrangePI $i at a later time (y/n)?"  InstallLater
                                        while [ $InstallLater != n ] && [ $InstallLater != y ];
                                        do echo 'Please answer with y or n'
                                        read -p "Do you want to install skywire on OrangePI $i at a later time (y/n)?"  InstallLater
                                        done

                                        if [ $InstallLater = y ]; then echo "Continuing with the installation process....."
                                        elif [ $InstallLater = n ]
                                        then ping -q -c2 $i > /dev/null
                                                if [ $? -ne 0 ]; then
                                                        echo "OrangePI $i is still not reachable. You will have to install it later on this OrangePI. Continuing the installation process without this OrangePI......"
                                                        else
                                                echo "OrangePI with IP: $i is finally up. Continuing with the installation process......"
                                                fi
                                        fi
                                else
                                 echo "OrangePI with IP: $i is now up"
                                fi

                elif [ $Continue = n ]; then
                        echo "You are not going to install on OrangePI $i for now. Continuing the installation process without it......"
                fi
  fi
}
for i in 192.168.0.{102..108}; do is_alive_ping $i; done


###### Install sshpass in order to login to OrangePI boards 2-8 using ssh
sudo apt-get install sshpass

##### Create a file where the trusted list of SSH keys will be stored
sudo mkdir ~/.ssh/
sudo touch ~/.ssh/known_hosts

###### Scan and add keys to trusted list
ssh-keyscan -H 192.168.0.102 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.103 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.104 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.105 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.106 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.107 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.0.108 >> ~/.ssh/known_hosts

###### In order to automatically install OrangePI 2-8 we need to login via SSH and run the SkyInstallScript...
###### ... for secondory boards.
###### Connect to OrangePI 2 and run installation
sshpass -p $RootPassword ssh root@192.168.0.102 << EOF
sudo wget https://raw.githubusercontent.com/Warmat/SkyInstallScript/master/SkyInstallScriptSecondary.sh
sudo chmod 755 ~/SkyInstallScriptSecondary.sh;
sudo sh ~/SkyInstallScriptSecondary.sh &&  exit
EOF
###### Connect to OrangePI 3 and run installation
sshpass -p $RootPassword ssh root@192.168.0.103 << EOF
sudo wget https://raw.githubusercontent.com/Warmat/SkyInstallScript/master/SkyInstallScriptSecondary.sh
sudo chmod 755 ~/SkyInstallScriptSecondary.sh;
sudo sh ~/SkyInstallScriptSecondary.sh &&  exit
EOF
###### Connect to OrangePI 4 and run installation
sshpass -p $RootPassword ssh root@192.168.0.104 << EOF
sudo wget https://raw.githubusercontent.com/Warmat/SkyInstallScript/master/SkyInstallScriptSecondary.sh
sudo chmod 755 ~/SkyInstallScriptSecondary.sh;
sudo sh ~/SkyInstallScriptSecondary.sh &&  exit
EOF
###### Connect to OrangePI 5 and run installation
sshpass -p $RootPassword ssh root@192.168.0.105 << EOF
sudo wget https://raw.githubusercontent.com/Warmat/SkyInstallScript/master/SkyInstallScriptSecondary.sh
sudo chmod 755 ~/SkyInstallScriptSecondary.sh;
sudo sh ~/SkyInstallScriptSecondary.sh &&  exit
EOF
###### Connect to OrangePI 6 and run installation
sshpass -p $RootPassword ssh root@192.168.0.106 << EOF
sudo wget https://raw.githubusercontent.com/Warmat/SkyInstallScript/master/SkyInstallScriptSecondary.sh
sudo chmod 755 ~/SkyInstallScriptSecondary.sh;
sudo sh ~/SkyInstallScriptSecondary.sh &&  exit
EOF
###### Connect to OrangePI 7 and run installation
sshpass -p $RootPassword ssh root@192.168.0.107 << EOF
sudo wget https://raw.githubusercontent.com/Warmat/SkyInstallScript/master/SkyInstallScriptSecondary.sh
sudo chmod 755 ~/SkyInstallScriptSecondary.sh;
sudo sh ~/SkyInstallScriptSecondary.sh &&  exit
EOF
###### Connect to OrangePI 8 and run installation
sshpass -p $RootPassword ssh root@192.168.0.108 << EOF
sudo wget https://raw.githubusercontent.com/Warmat/SkyInstallScript/master/SkyInstallScriptSecondary.sh
sudo chmod 755 ~/SkyInstallScriptSecondary.sh;
sudo sh ~/SkyInstallScriptSecondary.sh && exit
EOF



###### Clear root password variable
unset $RootPassword

##### SUCCESSFUL INSTALLATION NOTIFICATION
echo "Congratulation your Skyminer is now fully installed!"
echo "Happy earnings!"
echo "Please consider a small donation if you like our script!"
echo "SKYCOIN: zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB"
echo "BITCOIN: 0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0"
echo "ETHEREUM: 1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ"
echo
echo "If you run into any issues, please open an Issue on our GitHub so we can fix it!"
echo "In case you need further assistence feel free to contact us."



