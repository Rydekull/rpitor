#!/bin/bash
# This script will be executed by the docker container started by runme.sh

# Install stuff we need
apt update ; apt upgrade -y ; apt install bzip2 dosfstools zip cpio kmod xz-utils curl pwgen git gpg binutils bc -y ; apt clean

# Go to the scripts directory and generate files
cd /rpitor/scripts/setup-image ; yes | bash setup-image.sh 

# Remote any previous copy of raspbian-ua-netinst and clone it down again
rm -rf raspbian-ua-netinst/ ; git clone https://github.com/debian-pi/raspbian-ua-netinst.git

# Moves files into dir
mv post-install.txt installer-config.txt raspbian-ua-netinst/ 

cd raspbian-ua-netinst/

# Work around issue in raspbian-ua-netinst that assume we do not have any loopback devices
# Fixme: This will probably fail if you do not have any
let NUM=$(losetup -l | awk '$1 ~ /^\// { print $1 }' | sort -n | tail -1 | rev | cut -c1)+1
sed -i "s/loop0/loop${NUM}/g" buildroot.sh

# Execute builds
./build.sh ; ./buildroot.sh

# Show produced build
ls -la raspbian-ua-netinst*
