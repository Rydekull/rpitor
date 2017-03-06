#!/bin/bash
# Since we cannot do a docker build with loopback filesystems and privileges, not to mention volumes added read-write we are forced to use a run

# Default container to use
CONTAINER=debian:unstable

# Check if we already have a rpitor image built, if so we can skip a few steps
if [ "$(sudo docker images rpitor | grep -c rpitor)" -ge "1" ]
then
  CONTAINER=rpitor
fi

# Check if we really want to rebuild
if [ "$1" == "--rebuild" ]
then
  CONTAINER=debian:unstable
fi

# Run build
sudo docker run -it -v $(dirname $(pwd)):/rpitor:z -v /dev:/dev --privileged $CONTAINER bash /rpitor/docker/docker-setup.sh

# Check for success, if so commit so we can skip steps later if we want
if [ "$?" = "0" ]
then
  sudo docker commit $(sudo docker ps -f exited=0 -l --format="{{.ID}}") rpitor:latest
fi
