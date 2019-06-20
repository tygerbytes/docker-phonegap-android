#!/bin/bash

containerId=$(docker ps -qf "name=phonegap-android")
if [ $containerId ]
then
    echo "Stopping running container $containerId"
    docker container stop $containerId
fi

echo 'Starting Docker container'
containerId=$(docker run --rm -id --name phonegap-android -v $PWD:/build tygerbytes/phonegap-android-builder:latest)

echo Try create an user with UID '1001' inside the container.
docker exec $containerId bash -c "grep 1001 /etc/passwd | cut -f1 -d:"
docker exec $containerId useradd -m -u 1001 vsts_azpcontainer

echo Grant user 'vsts_azpcontainer' SUDO privilege and allow it run any command without authentication.
docker exec $containerId groupadd azure_pipelines_sudo
docker exec $containerId usermod -a -G azure_pipelines_sudo vsts_azpcontainer
docker exec $containerId su -c "echo '%azure_pipelines_sudo ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

echo Launch interactive shell as vsts_azpcontainer
docker exec -it $containerId /bin/bash -c 'su vsts_azpcontainer;'

