# Zigbee2MQTT_Setup
This repository uses scripts to configure your Raspberry PI or other device using linux to use Zigbee2MQTT


### Step 1:
Create script named "setup_z2m.sh" with command :

sudo nano setup_z2m.sh

-------------------------------------------------------------------------------------

### Step 2:
Grant execution privilege to "./setup_z2m.sh" with command :

chmod +x setup_z2m.sh

-------------------------------------------------------------------------------------

### Step 3:
Execute script with command :

sudo ./setup_z2m.sh

-------------------------------------------------------------------------------------

### Step 4:
After Execution run the following commands to list processes using /dev/ttyUSB0 :

sudo lsof /dev/ttyUSB0

-------------------------------------------------------------------------------------

### Step 5:
Kill processes using /dev/ttyUSB0 with command :

sudo kill -9 PID

-------------------------------------------------------------------------------------
### N.B : Step 4 and Step 5 will be required every time you stop the service from running
