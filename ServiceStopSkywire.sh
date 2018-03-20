#!/bin/bash
#######################################################################################################################################################################
#######################################################################################################################################################################
##### SKYWIRE SERVICES STOP SCRIPT
##### This script stops all Skywire services. They can be restarted with the start script.
#######################################################################################################################################################################
##### Version:		1.0  - Get the newest version at https://github.com/TheSKYpeople/SkyInstallScript
#######################################################################################################################################################################
##### Team:			  The SKYpeople (Email: TheSKYpeople@protonmail.com - Telegram: @TheSKYpeople)
##### Licence:		GNU General Public License v3.0
##### Donations:	Skycoin      zrwaGKR8oG7juYLHqgj7zwxH4bGYPEwWTB
#####				      Ethereum     0x25a4cc8003a626e0b1d0be4626dc33e82a0096a0
#####				      Bitcoin 	 1EH9Sw1JgnndJGVnUsQkhhiA6XBynqUFuQ
#######################################################################################################################################################################
#######################################################################################################################################################################

##### This stops the Skywire node
ps aux | grep manager | grep -v grep | awk '{ print $2 }' | xargs kill -9


###### This stops the Skywire monitor
ps aux | grep node | grep -v grep | awk '{ print $2 }' | xargs kill -9
