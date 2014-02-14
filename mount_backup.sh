#!/bin/sh

## sleep 10 minutes
#sleepTime=600
sleepTime=5

## parameter
kind="$1"

testMounted () {
    systemctl is-active mnt-backup.mount > /dev/null
    return $?
}

askMount () {
    if $1; then
	text="Trying to backup (${kind}), but your backup location is not mounted. Please attach your external hard drive."
	ok="Ok, HDD is attached."
    else
	text="Unable to mount your drive. Please make sure it is connected!"
	ok="Ok, try again."
    fi

    yad --title "Backup (${kind})" \
	--text "$text" \
	--button="Remind me later (10 minutes):1" \
	--button="Cancel Backup:2" \
	--button="$ok:0"
    return $?

#    if $1; then
#	zenity --question \
#	    --text  \
#	    --ok-label="Ok, HDD is attached." \
#	    --cancel-label="No, but ..." \
#	    --title "Backup (${kind})"
#	return $?
#    else
#	zenity --question \
#	    --text  \
#	    --ok-label="Ok, try again." \
#	    --cancel-label="No, but ..." \
#	    --title "Backup (${kind})"
#	return $?
#    fi
}

#askDelay () {
#    zenity --question \
#	--text "How to proceed?" \
#	--ok-label="Remind me later (10 minutes)" \
#	--cancel-label="Cancel Backup!" \
#	--title "Backup"
#}

requireMount () {
    first=true
    while ! testMounted; do
	askMount $first
	bla=$?
	case $bla in
	    1)
		delay=true
		return 1
		;;
	    2)
		delay=false
		return 1
		;;
	esac
#	if ! askMount $first; then
#	    delay=askDelay
#	    return 1
#	fi
	pmount UUID=37f594de-c5a2-45ab-96e0-765f805edce1
	first=false
    done
    return 0
}

while ! requireMount; do
    if $delay; then
	sleep $sleepTime
    else
	zenity --info \
	    --text "Backup cancelled" \
	    --title "Backup"
	exit 1
    fi
done

zenity --info \
    --text "Starting backup: ${kind}. Please do not disconnect your backup drive." \
    --title "Backup ${kind}"