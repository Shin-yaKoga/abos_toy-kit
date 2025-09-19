#!/bin/sh

PIPE="/tmp/container/mypipe"

if [ -e "$PIPE" ]; then
        echo "now, send the notification"
        echo "done" >"$PIPE"
else
        echo "wait the pipe..."
        while [ ! -e "$PIPE" ]
        do
                sleep 1
        done
        echo "got it."
fi

echo "wait a request..."
REQ=$(cat "$PIPE")
echo "got a request: $REQ"
