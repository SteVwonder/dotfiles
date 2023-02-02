#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

if [[ -z "$RESTIC_PASSWORD" ]]; then
    echo "Missing RESTIC_PASSWORD" >&2
    exit 1
elif [[ -z "$RESTIC_REPOSITORY" ]]; then
    echo "Missing RESTIC_REPOSITORY" >&2
    exit 1
elif [[ -z "$1" ]]; then
    echo "Missing directories to backup" >&2
    exit 1
fi

export PATH=$PATH:/usr/local/bin/

LOGDIR=${HOME}/.restic/logs/
mkdir -p $LOGDIR

LOGDATE=$(date +%Y-%m-%dT%H-%M-%S)
exec > ${LOGDIR}/${LOGDATE}.log
exec 2>&1

unameOut="$(uname -s)"
# Some operations are expensive. Only run them if on AC power
if [[ "$unameOut" == "Darwin" ]]; then
    ON_AC=$(/usr/sbin/system_profiler SPPowerDataType | grep -A3 "AC Charger" | grep "Connected" | awk '{print $2}')
elif [[ "$unameOut" == "Linux" ]]; then
    # TODO: need to implement
    ON_AC=""
else
    echo "Unknown OS: $unameOut" >&2
    exit 1
fi

dirs=( "$@" )
restic --verbose backup --one-file-system ${dirs[@]}

restic forget --keep-hourly 8 --keep-daily 7 --keep-weekly 4 --keep-monthly 6

if [[ $ON_AC == "Yes" ]]; then
    # TODO: make a separate restic check script
    #restic check --read-data-subset=1G
    restic prune
fi
