#!/bin/sh
export PASSPHRASE="<passphrase>"
#DEST=file:///mnt/backup/etc
DEST=file:///mnt/nfs_backup/etc
SRC=/etc

duplicity --full-if-older-than 1M $SRC $DEST
duplicity remove-older-than 1Y --force $DEST
duplicity verify $DEST $SRC
unset PASSPHRASE
