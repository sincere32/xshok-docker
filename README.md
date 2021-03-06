# xshok-docker :: eXtremeSHOK.com Docker

Scripts for working with docker

## Docker Optimization / Post Install Script for Ubuntu (xshok-ubuntu-docker-host.sh) *run once*
Turns a fresh ubuntu install into an optimised docker host
* Force APT to use IPv4
* Remove conflicting utilities
* Update and Install common system utilities
* Remove no longer required packages and purge old cached updates
* Detect if virtual machine and install guest agent (qemu/kvm, vmware, virtualbox)
* Detect cloud-init device and install cloud-init
* Disable portmapper / rpcbind (security)
* Disable SSH password logins (security) if Authorized_keys detected
* Disable local dns server, do not disable systemd-resolved as this breaks nameservers configured with netplan
* set-timezone UTC and enable timesyncd as nntp client
* Create a swapfile (default is 4GB, configurable with SWAPFILE_SIZE)
* Bugfix: high swap usage with low memory usage
* Pretty MOTD BANNER (configurable with NO_MOTD_BANNER)
* Increase max user watches
* Increase max FD limit / ulimit
* Increase kernel max Key limit
* Set systemd ulimits
* Set ulimit for the shell user
* Enable unattended upgrades
* Install Docker-ce
* Install Docker-compose
* Enable TCP BBR congestion control, improves overall network throughput
* Disable Transparent Hugepage before Docker boots

### Notes:
* to disable the MOTD banner, set the env NO_MOTD_BANNER to true (export NO_MOTD_BANNER=true)
* to set the swapfile size to 1GB, set the env SWAPFILE_SIZE to 1 (export SWAPFILE_SIZE=1)
* Disable swapfile (export SWAPFILE_SIZE=0)
```
wget https://raw.githubusercontent.com/extremeshok/xshok-docker/master/xshok-ubuntu-docker-host.sh -O xshok-ubuntu-docker-host.sh && chmod +x xshok-ubuntu-docker-host.sh && ./xshok-ubuntu-docker-host.sh
```

## Docker Initialization / Start docker-compose.yml (xshok-init-docker.sh)
Starts your docker-compose based containers properly
* Automatically creates volume directories and touches volume files
* Stops all running containers
* Removes any orphaned containers
* Pull/download dependencies and images
* Forces recreation of all containers and will build required containers

### NOTES:
*  Script must be placed into the same directory as the docker-compose.yml
```
wget https://raw.githubusercontent.com/extremeshok/xshok-docker/master/xshok-init-docker.sh -O xshok-init-docker.sh && chmod +x xshok-init-docker.sh
bash xshok-init-docker.sh
```

## Docker Cleaning / Stop docker-compose.yml (xshok-clean-docker.sh)
Stops your docker-compose based containers properly
* Stops all running containers
* Removes any orphaned containers amd images

### NOTES:
*  Script must be placed into the same directory as the docker-compose.yml
```
wget https://raw.githubusercontent.com/extremeshok/xshok-docker/master/xshok-clean-docker.sh -O xshok-clean-docker.sh && chmod +x xshok-clean-docker.sh
bash xshok-clean-docker.sh
```

## Creates a systemd service to start/stop docker-compose.yml  (xshok-add-systemd-service.sh)
Creates a systemd service to start / stop your docker-compose
* On Start: Forces recreation of all containers and will build required containers
* On Stop: Stops all running containers, Removes any orphaned containers
* On Reload: quickest, docker-compose stop and start
### NOTES:
*  Script must be placed into the same directory as the docker-compose.yml
```
wget https://raw.githubusercontent.com/extremeshok/xshok-docker/master/xshok-add-systemd-service.sh -O xshok-add-systemd-service.sh && chmod +x xshok-add-systemd-service.sh
bash xshok-add-systemd-service.sh
```
