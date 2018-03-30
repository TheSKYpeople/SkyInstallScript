#!/bin/bash
 
#######################################################################################################################################################################
#######################################################################################################################################################################
##### SKYMINER (SKYCOIN) ORANGE PI AUTO INSTALL SCRIPT - REMOTE PART
##### This script prepares the remote install to OrangePI 2-8 and runs the remote installation on those boards via SSH
##### For more detailed instructions please consult our tutorial.
##### For further assistence feel free to contact us! 
#######################################################################################################################################################################
##### Version:      1.0  - Get the newest version at https://github.com/TheSKYpeople/SkyInstallScript
#######################################################################################################################################################################
##### Team:                The SKYpeople (Email: TheSKYpeople@protonmail.com - Telegram: @TheSKYpeople)
##### Licence:           GNU General Public License v3.0
##### Donations:        Skycoin      zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB
#####                           Ethereum     0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0
#####                           Bitcoin         1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ
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
