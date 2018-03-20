#!/bin/bash

#######################################################################################################################################################################
#######################################################################################################################################################################
##### SKYCOIN WALLET AUTO START SCRIPT
##### AS A PART OF SKYMINER (SKYCOIN) ORANGE PI AUTO INSTALL SCRIPT
##### This script starts the Skycoin wallet again after a shutdown or reboot automatically.
#######################################################################################################################################################################
##### Version:		1.0  - Get the newest version at https://github.com/TheSKYpeople/SkyInstallScript
#######################################################################################################################################################################
##### Team:			  The SKYpeople (Email: TheSKYpeople@protonmail.com - Telegram: @TheSKYpeople)
##### Licence:		GNU General Public License v3.0
##### Donations:	Skycoin      zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB
#####				      Ethereum     0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0
#####				      Bitcoin 	   1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ
#######################################################################################################################################################################
#######################################################################################################################################################################


###### Change into Skycoin directory
cd $GOPATH/src/github.com/skycoin/skycoin

###### Launching Skycoin in the background
make run > /dev/null 2>&1 &
