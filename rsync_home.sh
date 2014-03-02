#!/bin/sh

DEST=/mnt/backup/rsync

bu () {
	rsync -a --delete $HOME/$1 $DEST
}

bu dateien
bu Videos
bu Musik
bu Bilder
bu Downloads
