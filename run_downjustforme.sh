#!/bin/bash

export DISPLAY=:9

DOWNJUSTFORME_HOME="/home/xxx/srv_xxx/downjustforme/"
cd $DOWNJUSTFORME_HOME

logfile="$DOWNJUSTFORME_HOME/logs/downjustforme.log"
script=$(pwd | rev | cut -d"/" -f1-2 | rev | tr '/' '_')
lockdir="/tmp/$script.lock"

if mkdir "$lockdir" 2>> $logfile; then
    echo "### $(date): successfully acquired lock: $lockdir ###" >> $logfile
    trap 'rm -rf "$lockdir"' 0    # remove directory when script finishes
else
    echo "### $(date): cannot acquire lock, giving up on $lockdir ###" >> $logfile
    exit 0
fi

source downjustforme.env/bin/activate
python downjustforme/run.py "$@"
