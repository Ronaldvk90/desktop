FROM fedora:39

RUN dnf update -y
RUN dnf install -y @xfce-desktop-environment
RUN dnf install -y --allowerasing xrdp vim git zsh htop firefox thunderbird pulseaudio
RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/user

COPY run.sh /.run.sh
RUN chmod +x /.run.sh

ENTRYPOINT [ "/.run.sh" ]
