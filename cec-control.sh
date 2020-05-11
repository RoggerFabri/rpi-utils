#!/bin/bash

VERBOSE=0                      # print echov lines if VERBOSE == 1

type cec-client &>/dev/null || { echo "cec-client is required"; exit; }

     echov(){ [[ "$VERBOSE" == "1" ]] && echo $@                              ; }
filter_key(){ grep -q "key pressed: $1 .* duration" <( echo "$2" )            ; }

while :; do
  cec-client | while read l; do
    echov $l

    pgrep kodi && { echov "Ignoring key, Kodi is already running."; continue; }

    if  filter_key "F2 (red)" "$l"; then
      {
        echov "Starting Kodi..."
        ( speaker-test -t sine -c 2 -s 2 -f 800 & TASK_PID=$! ; sleep 0.10 ; kill -s SIGINT $TASK_PID ) > /dev/null
        kodi-standalone
        killall cec-client
      }
      break
    fi
  done
done

# *** USAGE EXAMPLE ***
#
# chmod u+x cec-control.sh
# sudo -u pi nohup <path_to_script>/cec-control.sh 0 2>/dev/null &
#
# *** USAGE EXAMPLE ***