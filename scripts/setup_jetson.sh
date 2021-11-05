#!/usr/bin/env bash

PKG_NAME="jetson_svo_docker"
# configure dialout group

# Add docker group and user to it
echo " " && echo "Docker configuration ..." && echo " "
sudo groupadd docker
sudo gpasswd -a $(whoami) docker

# Enable docker automatically after system boot
# Reference: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot
 sudo systemctl enable docker.service
 sudo systemctl enable containerd.service

# Adjust serial port permissions
echo " " && echo "Serial ports configuration (ttyTHS1) ..." && echo " "
sudo usermod -aG dialout $(whoami)
sudo usermod -aG tty $(whoami)

echo " " && echo "Adding udev rules for /dev/ttyTHS* ..." && echo " " && sleep 1
echo 'KERNEL=="ttyTHS*", MODE="0666"' | sudo tee /etc/udev/rules.d/55-tegraserial.rules
# nvgetty needs to be disabled in order to set ppermanent permissions for ttyTHS1 on jetson nano
# see (https://forums.developer.nvidia.com/t/read-write-permission-ttyths1/81623/5)

echo " " && echo "Disabling nvgetty ..." && echo " " && sleep 1
sudo systemctl stop nvgetty
sudo systemctl disable nvgetty
sudo udevadm trigger


echo && echo "Install udev rules for Realsense D435..."
cd $HOME/src/${PKG_NAME}/scripts
./installRealsenseUdev.sh


cd $HOME/src/${PKG_NAME}/
echo " " && echo "Building Dockerfile.svo ..." && echo " " && sleep 1
./scripts/docker_build_svo.sh melodic

echo " " && echo "Adding alias to .bashrc script ..." && echo " "
grep -xF "alias svo_container='source \$HOME/src/jetson_svo_docker/scripts/docker_run_svo.sh'" ${HOME}/.bashrc || echo "alias svo_container='source \$HOME/src/jetson_svo_docker/scripts/docker_run_svo.sh'" >> ${HOME}/.bashrc

echo " " && echo "#------------- You can run the svo container from the terminal by executing svo_container -------------#" && echo " "

cd $HOME

echo "#------------- Please reboot your Jetson before running executing the svo_container alias, for some changes to take effect -------------#" && echo "" && echo " "
