#!/bin/bash
#
# set up macOS PAM to use YubiKey
# uses sudo to modify system files, so a macOS "Admin" account is needed to run
#
PATH=/usr/bin:/bin:/usr/sbin:/sbin

readonly PAMDIR=/etc/pam.d
readonly AUTHFILE=authorization
readonly SCREENSAVERFILE=screensaver
readonly YUBILIB=/usr/local/lib/security/pam_yubico.so
readonly DATESTAMP=$(date +%Y%m%dT%H%M%S)
readonly INSTALLDIR=$(pwd)
readonly THISONE=$(basename $0)
readonly MYTMPDIR=/tmp/tempdir.$RANDOM

# sticking to 80 character line length...
readonly PAM1="auth       required       "
readonly PAM2="/usr/local/lib/security/pam_yubico.so mode=challenge-response"
readonly PAMLINE="$PAM1""$PAM2"

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
    sudo cp -p ${PAMDIR}/$myfile ${PAMDIR}/${myfile}.$DATESTAMP
    # enable YubiKey
    # search for first "account required" line and insert a new line before this
    # using a temp file and "-e" to get around newline issue on macOS/POSIX sed
    mkdir $MYTMPDIR
    sed -e '/account.*required.*pam_opendirectory.so/i\'$'\n'"$PAMLINE"\
    ${PAMDIR}/$myfile >${MYTMPDIR}/$myfile
    if $(sudo cp ${MYTMPDIR}/$myfile ${PAMDIR}/$myfile 2>/dev/null);then
      sudo chown root ${PAMDIR}/$myfile
      sudo chgrp wheel ${PAMDIR}/$myfile
      sudo chmod 644 ${PAMDIR}/$myfile
      changes=$((changes+1))
      rm ${MYTMPDIR}/$myfile
      rmdir $MYTMPDIR
    else 
      echo "ERROR: $THISONE could not update ${PAMDIR}/$myfile, giving up" >&2
      exit 3
    fi
  fi
done

if [[ $changes -eq 0 ]]; then
  echo "INFO: $THISONE finished, no changes made to system"
else
  echo "INFO: $THISONE PAM setup for YubiKey done, $changes file(s) changed"
fi

exit 0