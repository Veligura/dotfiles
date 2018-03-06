#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo -e "Usage examples:\n$0 inc\n$0 dec\n$0 bat\n$0 ac" >&2
  exit 1
fi

# Restore last brightness value for battery or AC
if [[ "$1" == "bat" || "$1" == "ac" ]]; then

  light -S $(< /home/alex/.brightness_$1)
  py3-cmd refresh backlight
  exit 0
fi

# Increase or decrease current brightness value
if [ "$1" == "inc" ]; then
  py3-cmd click 4 backlight
else
  py3-cmd click 5 backlight
fi

# Save brightness value to a file

new=$(light)

battery_statuses=$(acpi | grep -Po '(?<=: )\w+' | tr "\n" "\n")

for stat in $battery_statuses;
do
   if [[ "$stat" == "Charging" || "$stat" == "Discharging" ]]; then
    battery_status=$stat
  fi
done

if [[ "$battery_status" == "Discharging" ]]; then
  power="bat"
else
  power="ac"
fi
echo "$new" > /home/alex/.brightness_$power
