#!/bin/sh

PIPE="/tmp/container/mypipe"

echo "Hello from a container."

if [ ! -e "$PIPE" ]; then
    mkfifo "$PIPE"
fi

while true
do
    echo "do something..."
    sleep 30
    echo "done, so enter sleep."

    echo "sleep" >"$PIPE"
    RESP=$(cat "$PIPE")
    echo "waked up."
    echo ""
done
