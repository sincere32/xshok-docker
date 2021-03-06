#!/usr/bin/env bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
# Script updates can be found at: https://github.com/extremeshok/xshok-docker
#
# Creates a systemd service to start / stop your docker-compose
#
# On Start: Forces recreation of all containers and will build required containers
# On Stop: Stops all running containers, Removes any orphaned containers
#
# License: BSD (Berkeley Software Distribution)
#
################################################################################
#
# Assumptions: Docker and Docker-compose Installed
#
# Tested on KVM, VirtualBox and Dedicated Server
#
# Notes:
# Script must be placed into the same directory as the docker-compose.yml
# Support for xshok-init-docker.sh and  xshok-clean-docker.sh
#
# Usage:
# wget https://raw.githubusercontent.com/extremeshok/xshok-docker/master/xshok-add-systemd-service.sh -O xshok-add-systemd-service.sh && chmod +x xshok-add-systemd-service.sh
# bash xshok-add-systemd-service.sh
#
################################################################################
#
#    THERE ARE NO USER CONFIGURABLE OPTIONS IN THIS SCRIPT
#
################################################################################

if [ ! -d "/etc/systemd/system/" ] ; then
  echo "ERROR: systemd not detected"
  exit 1
fi

dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${dirname}" || exit 1
if [ ! -f "docker-compose.yml" ] ; then
  echo "ERROR: docker-compose.yml not found, must be run in the same directory"
  exit 1
fi

# remove beginning /
thisname="${dirname#/}"
# remove ending /
thisname="${thisname%/}"
# space with -
thisname="${thisname// /-}"
# / with _
thisname="${thisname//\/_}"
# remove .
thisname="${thisname//\.}"


echo "Generating Systemd service"
cat <<EOF > "/etc/systemd/system/docker-${thisname}.service"
[Unit]
Description=Docker Compose ${thisname} Service
Requires=docker.service
After=docker.service

[Install]
WantedBy=multi-user.target

[Service]
Type=oneshot
WorkingDirectory=${dirname}
EOF

if [ -f xshok-init-docker.sh ] ; then
  echo "ExecStart=/bin/bash ${dirname}/xshok-init-docker.sh" >> "/etc/systemd/system/docker-${thisname}.service"
else
  echo "ExecStart=/usr/local/bin/docker-compose up -d --force-recreate --build" >> "/etc/systemd/system/docker-${thisname}.service"
fi

#echo "ExecReload=/usr/local/bin/docker-compose stop && /usr/local/bin/docker-compose start" >> "/etc/systemd/system/docker-${thisname}.service"
#
# if [ -f xshok-clean-docker.sh ] ; then
#   echo "ExecStop=/bin/bash ${dirname}/xshok-clean-docker.sh" >> "/etc/systemd/system/docker-${thisname}.service"
# else
#   echo "ExecStop=/usr/local/bin/docker-compose down --remove-orphans" >> "/etc/systemd/system/docker-${thisname}.service"
# fi

echo "Created: /etc/systemd/system/docker-${thisname}.service"
systemctl daemon-reload
systemctl enable docker-${thisname}

echo "Available Commands:"
echo "Start-> systemctl start docker-${thisname}"
#echo "Stop-> systemctl stop docker-${thisname}"
#echo "Reload-> systemctl reload docker-${thisname}"
