#!/bin/bash
# set up MacOS to use YubiKey
# use setupuser for setting up a new user 

datestamp=$(date +%Y%m%dT%H%M%S)
sudo cp -p /etc/pam.d/screensaver /etc/pam.d/screensaver.$datestamp
sudo cp -p /etc/pam.d/authorization /etc/pam.d/authorization.$datestamp
sudo cp ~/Build/screensaver /etc/pam.d/screensaver
sudo cp ~/Build/authorization /etc/pam.d/authorization
sudo chown root /etc/pam.d/screensaver /etc/pam.d/authorization
sudo chgrp wheel /etc/pam.d/screensaver /etc/pam.d/authorization
sudo chmod 644 /etc/pam.d/screensaver /etc/pam.d/authorization
