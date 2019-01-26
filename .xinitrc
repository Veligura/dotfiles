#!/usr/bin/env zsh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# merge in user configs

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

# Load environment variables for GUI apps

source ~/.zsh/environment.zsh

# Initial configuration and autostart some apps
xset b 0 0 0
xrandr --dpi 94                                           # Set High DPI
hsetroot -solid "#333333"                                  # Set desktop color
compton &                                                  # Enable composition
start-pulseaudio-x11 &                                     # Pulse audio daemon
xset s off -dpms                                           # Prevent screen from turning off
xset r rate 660 25
xset m 3/1 4                                               # Set mouse cursor speed
xset -b
numlockx &                                                 # Turn on NumLock
unclutter &                                                # Hide mouse when using keyboard

copyq &                                                    # Clipboard manager
hotshots &                                                 # Screenshot manager
udiskie --smart-tray &                                     # Automatically mount usb drives
thunderbird &                                              # Mail
~/bin/server_notify.pl &                                   # libnotify over ssh
exec i3                                                    # WM
