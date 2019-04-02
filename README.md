# yubienabler-macos #
A small project to enable the use of YubiKeys on MacOS.

## Using ##
Clone the project and run yubipam.sh.

## Prerequisites ##
* Yubico PAM for MacOS software
* you will need to run scripts as a MacOS user with 'Admin' (sudo) privileges
* /etc/pam.d/authorization and screensaver as originally distributed
## Files ##

File | Purpose
---- | -------
authorization.dist| authorization file as distributed in MacOS, for recovery
authorization.yubi| authorization file with Yubico PAM enabled
screensaver.dist| screensaver file as distributed in MacOS, for recovery
screensaver.yubi| screensaver file with Yubico PAM enabled
yubipam.sh|systemwide setup for use of YubiKeys with PAM,
.|run after install of YubiKey software and MacOS upgrades
README.md|this file

