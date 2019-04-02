#!/bin/bash
#
# set up MacOS PAM to use YubiKey
# uses sudo to modify system files, so a MacOS "Admin" account is needed to run
#
PATH=/usr/bin:/bin:/usr/sbin:/sbin
readonly PAMDIR=/etc/pam.d
readonly AUTHFILE=authorization
readonly SCREENSAVERFILE=screensaver
readonly YUBILIB=/usr/local/lib/security/pam_yubico.so
readonly DATESTAMP=$(date +%Y%m%dT%H%M%S)
readonly INSTALLDIR=$(pwd)
readonly THISONE=$(basename $0)
changes=0

echo "INFO: $THISONE checking sudo access"
if ! $(sudo -v); then
  echo "ERROR: $THISONE no sudo access, giving up" >&2
  exit 1
fi

for myfile in $AUTHFILE $SCREENSAVERFILE; do
  if [[ ! -f ${PAMDIR}/$myfile ]]; then
      echo "ERROR: $THISONE ${PAMDIR}/$myfile does not exist, giving up" >&2
      exit 2
  fi
done

for myfile in $AUTHFILE $SCREENSAVERFILE; do
  # ignore comment lines, then check if PAM already configured for YubiKey
  if $(grep -v ^[[:blank:]]*# ${PAMDIR}/$myfile | grep -q $YUBILIB 2>/dev/null)
  then
    echo "INFO: $THISONE PAM setup for YubiKey"\
     "in $myfile looks to already be in place"
  else
    echo "INFO: $THISONE adding PAM setup for YubiKey in $myfile"
    # create a backup and copy YubiKey enabled file in place
    # TODO(tuxops): Use (MacOS=POSIX) sed/awk instead of copying in new file
    sudo cp -p ${PAMDIR}/$myfile ${PAMDIR}/${myfile}.$DATESTAMP
    sudo cp ${INSTALLDIR}/${myfile}.yubi ${PAMDIR}/$myfile
    sudo chown root ${PAMDIR}/$myfile
    sudo chgrp wheel ${PAMDIR}/$myfile
    sudo chmod 644 ${PAMDIR}/$myfile
    changes=$((changes+1))
  fi
done

if [[ $changes -eq 0 ]]; then
  echo "INFO: $THISONE finished, no changes made to system"
else
  echo "INFO: $THISONE PAM setup for YubiKey done, $changes file(s) changed"
fi

exit 0