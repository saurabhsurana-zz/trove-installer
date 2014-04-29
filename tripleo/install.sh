#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "Install dbaas-salt-box Log: This script must be run as root" 1>&2
   exit 1
fi

LOG_DIR=/var/log/trove-installer/`date +"%m-%d-%Y-%H-%M-%S"`
mkdir -p ${LOG_DIR}
chmod 777 ${LOG_DIR}
chown -R ubuntu:ubuntu ${LOG_DIR}

# Log to syslog and a separate file
exec > >(tee ${LOG_DIR}/trove-installer.log | logger -t dbaas-devstack-box -s 2>/dev/console) 2>&1

IMAGE_DIR=/opt/stack/trove_images
INSTALLER_HOME=/home/ubuntu/trove-installer/tripleo
DEVSTACK_HOME=/home/ubuntu/devstack
STACK_HOME=/opt/stack
IMAGE_DIR=/opt/stack/trove_images

RABBITMQ_IMAGE_NAME=trove-rabbitmq
MYSQL_IMAGE_NAME=trove-mysql
API_IMAGE_NAME=trove-api
CONDUCTOR_IMAGE_NAME=trove-conductor
TASKMANAGER_IMAGE_NAME=trove-taskmanager
GUEST_IMAGE_NAME=trove-guest

. ${INSTALLER_HOME}/helper/build_image_helper
. ${INSTALLER_HOME}/helper/devstack_helper
. ${INSTALLER_HOME}/helper/git_helper
. ${INSTALLER_HOME}/trove-guestimage-env
. ${INSTALLER_HOME}/helper/create_trove_stack

sudo apt-get install git curl wget -y

install_pip

install_devstack

. ${INSTALLER_HOME}/stackrc/stackrc-admin

sleep 10

mkdir -p ${IMAGE_DIR}
chmod 777 ${IMAGE_DIR}
chown -R ubuntu:ubuntu ${IMAGE_DIR}

clone_dbaas_git_repos
clone_upstream_git_repos

build_images

upload_images

setup_devstack_env

create_trove_stack

sleep 900

register_trove_service

