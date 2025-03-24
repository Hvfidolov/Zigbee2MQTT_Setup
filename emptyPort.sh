#!/bin/bash

# Target device
DEVICE="/dev/ttyUSB0"

# Check if device exists
if [ ! -e "$DEVICE" ]; then
    echo "Error: Device $DEVICE does not exist."
    exit 1
fi

# Get PIDs of processes using the device
PIDS=$(sudo lsof -t "$DEVICE" 2>/dev/null)

# Check if there are processes to kill
if [ -z "$PIDS" ]; then
    echo "No processes found using $DEVICE."
    exit 0
fi

# Kill the processes
echo "Terminating processes attached to $DEVICE:"
echo "$PIDS"
sudo kill -9 $PIDS

# Verify processes were killed
REMAINING=$(sudo lsof -t "$DEVICE" 2>/dev/null)
if [ -z "$REMAINING" ]; then
    echo "Success: All processes killed."
else
    echo "Warning: Some processes could not be killed:"
    echo "$REMAINING"
    exit 1
fi