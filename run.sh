#!/bin/bash

DIR="/home/$USER"
if [ -d "$DIR" ]; then
  # Remove annoying polkit message becouse systemd is broken in docker (obviously)
  rm /etc/xdg/autostart/xfce-polkit.desktop
  
  # Continue without parts of the user creation
  echo "Not the first time the container runs. Skipping parts of the user creation"
  groupadd --gid $USER_GID $USER
  useradd --uid $USER_UID --gid $USER_GID -M $USER
  echo "$USER:$PASSWORD" | chpasswd
  chsh -s /bin/zsh $USER
  usermod -a -G users,audio,video,wheel $USER

  # Make sure DBUS and xrdp-sesman run
  if [ -f "/run/dbus/pid" ]; then
      rm /run/dbus/pid
  fi

  if [ ! -d "/run/dbus" ]; then
    mkdir -p /run/dbus
  fi

  dbus-daemon --system

  if [ -f "/var/run/xrdp-sesman.pid" ]; then
      rm /var/run/xrdp-sesman.pid
  fi

  xrdp-sesman
  xrdp --nodaemon

else
  echo "First time the container is run. Arrange some stuff for you."
  
  # Remove annoying polkit message becouse systemd is broken in docker (obviously)
  rm /etc/xdg/autostart/xfce-polkit.desktop

  #Set your timezone
  ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
  echo "$HOSTNAME" > /etc/hostname

  # Prepare a user for the server
  groupadd --gid $USER_GID $USER
  useradd --uid $USER_UID --gid $USER_GID -m $USER
  echo "$USER:$PASSWORD" | chpasswd
  chsh -s /bin/zsh $USER
  usermod -a -G users,audio,video,wheel $USER

  # Make pulseaudio start at login
  mkdir -p /home/$USER/.config/xfce4
  printf '#!/bin/sh\npulseaudio -D\n. /etc/xdg/xfce4/xinitrc' >> /xinitrc
  mv /xinitrc /home/$USER/.config/xfce4/
  chown -R $USER:$USER /home/$USER/.config/xfce4

  # Take care of some xfce related stuff
  chmod -R 777 /home/$USER/.config
  mkdir /home/$USER/.cache
  chmod -R 777 /home/$USER/.cache
  chown $USER:$USER /home/$USER/.config
  chown $USER:$USER /home/$USER/.cache
  echo "startxfce4" > /home/$USER/.xsession
  chown $USER:$USER /home/$USER/.xsession
  chmod +x /home/$USER/.xsession

  # Make shure DBUS and xrdp-sesman run
  if [ -f "/run/dbus/pid" ]; then
      rm /run/dbus/pid
  fi

  if [ ! -d "/run/dbus" ]; then
    mkdir -p /run/dbus
  fi

  dbus-daemon --system

  if [ -f "/var/run/xrdp-sesman.pid" ]; then
      rm /var/run/xrdp-sesman.pid
  fi

  xrdp-sesman
  xrdp --nodaemon
fi
