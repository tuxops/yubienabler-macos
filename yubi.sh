#!/bin/bash
#
# set up MacOS PAM to use YubiKey
# using sudo to modify system files, so a MacOS "Admin" account is needed to run
#
readonly PAMDIR=/Users/hal/etcpam
readonly AUTHFILE=${PAMDIR}/authorization
readonly SCREENSAVERFILE=${PAMDIR}/screensaver
readonly YUBILIB=/usr/local/lib/security/pam_yubico.so
readonly DATESTAMP=$(date +%Y%m%dT%H%M%S)

for myfile in $AUTHFILE $SCREENSAVERFILE; do
  if [[ ! -f $myfile ]]; then
      echo "WARNING: $myfile does not seem to exist, skipping with no changes made"
  else
    # ignore all comment lines, then check for existence of YubiKey library already configured
    if $(grep -v ^[[:blank:]]*# $myfile | grep -q $YUBILIB 2>/dev/null); then
      echo "INFO: PAM setup for YubiKey in $myfile looks to already be in place"
    else
      echo "INFO adding PAM setup for YubiKey in $myfile"
      # create a backup
      sudo cp -p $myfile ${myfile}.$DATESTAMP
      
      sudo chown root $myfile
      sudo chgrp wheel $myfile
      sudo chmod 644 $myfile
    fi
  fi
done

  
