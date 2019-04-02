# yubienabler-macos #
A simple script to enable use of YubiKey on MacOS via updates in /etc/pam.d.
This to avoid manual mistakes are avoided.
Script to be run when installing YubiKey software and after MacOS upgrades.

## Using ##
Clone the project and run yubipam.sh.

## Prerequisites ##
You will need run the script as a MacOS user with 'Admin' privileges.

## Files ##

File | Purpose
---- | -------
authorization.dist| authorization file as distributed in MacOS, for recovery
authorization.yubi| authorization file with Yubico PAM enabled
screensaver.dist| screensaver file as distributed in MacOS, for recovery
screensaver.yubi| screensaver file with Yubico PAM enabled
yubipam.sh|script to enable use of YubiKeys with PAM