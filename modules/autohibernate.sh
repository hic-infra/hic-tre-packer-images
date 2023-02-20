#!/bin/bash

set -eu

# This module should be provisioned towards the end of the packer
# build, since it will immediately start checking if an X server is
# running an idle session.
#
# amazon-ec2-hibinit-agent does most of the work for us, but for some
# reason in Ubuntu 20.04, it seems we need to also reconfigure and
# rebuild the initramfs.
sudo apt install -y xprintidle xdotool

# In minutes, we need to convert this to ms
AUTOHIBERNATE_TIME=$(( AUTOHIBERNATE_TIME * 60 * 1000 ))

sudo tee /usr/bin/autohibernate <<EOF
#!/bin/bash

set -eu

AUTOHIBERNATE_TIME=$AUTOHIBERNATE_TIME
export DISPLAY=:1

if [ \$(xprintidle) -gt \$AUTOHIBERNATE_TIME ] ; then
  xdotool mousemove 0 0 # reset idle time

  # We need to enable the swap file to dump RAM to.
  sudo swapon /swap-hibinit

  # Just in case there is a client connected to the VNC server (there
  # shouldn't be), we should disconnect them to avoid confusing it
  # later. This is because the SSM client keeps the local port open
  # until the client disconnects, but the client stays connected
  # because the SSM port is still listening!
  vncconfig -disconnect

  # Let's hibernate.
  sudo systemctl hibernate

  # Without a sleep, the swap will be turned off too soon after
  # triggering the hibernate (which is async). We need to wait a
  # couple of seconds to ensure that the hibernation has been
  # actioned.
  sleep 5

  # We move the mouse again to ensure the idle time is close to 0. We
  # restart the SSM agent to force the instance to quickly register
  # with the ssm endpoint. Finally, we turn off the swap. We do this
  # after restarting the ssm agent as turning off the swap may take a
  # few moments, and during this time we won't be able to connect to
  # the instance.
  xdotool mousemove 0 0 # ensure idle time is 0
  sudo snap restart amazon-ssm-agent
  sudo swapoff /swap-hibinit
fi
EOF

sudo chmod +x /usr/bin/autohibernate

cat <<EOF | crontab
* * * * * /usr/bin/autohibernate
EOF


