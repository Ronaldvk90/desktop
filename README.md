# Welcome to my docker Desktop!

The goal of this server is basically to bring a ready to run instant Fedora XFCE desktop in docker for you. Based on xrdp. :)

At building it will create a user so it won't run as root.

# The business end.

**Environment file!** Don't forget about this one ;)
USER_UID=your user id (you can type "echo $UID for the id on your system)
USER_GID=your group id (you can type "echo $GID for the id on your system)
USERNAME=the username you want to give the Desktop (I would suggest your name)
TZ=your timezone. example, "Europe/London"
PASSWORD=Your verry secret password!
HOSTNAME=Your Hostname.

Edit the environment.env file to your needs.

then you just have to do a "make install" on your docker host, and your RDP server instanse is ready.
Make clean will stop the container. It will just do a "docker compose down".
Make clean-all will *DELETE* the container and home volume.
Make install-debug will do a compose up verbose start

It will also create a volume which is the home directory for the Desktop, where you can store your personal files.
If you don't have make installed, you can just run "docker compose up".
