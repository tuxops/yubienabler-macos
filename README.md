
# yubienabler-macos #

A small project to enable the use of YubiKeys on macOS.

## Using ##

Clone or download the project and execute yubipam.sh.

## Prerequisites ##

* read the Yubico macOS Logon Tool Configuration Guide before running
* Yubico PAM for macOS software (aka macOS Logon Tool)
* a YubiKey that has been initialised
* you will need to run scripts as a MacOS user with 'Admin' (sudo) privileges

## Files ##

File | Purpose
---- | -------
authorization.dist| authorization file as distributed in MacOS, for recovery
screensaver.dist| screensaver file as distributed in MacOS, for recovery
yubipam.sh|systemwide setup for use of YubiKeys with PAM,
.|run after install of YubiKey software or after MacOS upgrades
README.md|this file
