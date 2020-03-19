#!/bin/sh

export QT_STYLE_OVERRIDE=gtk
export QT_QPA_PLATFORM=wayland-egl
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1.5
export CLUTTER_BACKEND=wayland
#export GDK_DPI_SCALE=1.5
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

. $HOME/.nix-profile/etc/profile.d/nix.sh

PATH=$HOME/.local/bin:$PATH
export PATH

sway > /var/log/sway.log 2>&1
