#!/bin/bash
# Copyright 2014 Hewlett-Packard Development Company, L.P.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#


if [ "$(id -u)" != "0" ]; then
   echo "Install trove-salt-box Log: This script must be run as root" 1>&2
   exit 1
fi

CURRENT_TIME=`date +"%m-%d-%y-%H-%M"`
LOG_DIR=/var/log/trove-installer/${CURRENT_TIME}
mkdir -p ${LOG_DIR}
chmod 777 ${LOG_DIR}
chown -R ubuntu:ubuntu ${LOG_DIR}

# Log to syslog and a separate file
exec > >(tee ${LOG_DIR}/trove-installer.log | logger -t dbaas-devstack-box -s 2>/dev/console) 2>&1

IMAGE_DIR=/opt/stack/trove_images

if [ -d /home/ubuntu/trove-installer ]; then
    INSTALLER_HOME=/home/ubuntu/trove-installer/tripleo
else
    INSTALLER_HOME=/opt/stack/trove-installer/tripleo
fi

DEVSTACK_HOME=/home/ubuntu/devstack
STACK_HOME=/opt/stack
IMAGE_DIR=/opt/stack/trove_images

RABBITMQ_IMAGE_NAME=dbaas_rmq
MYSQL_IMAGE_NAME=dbaas_mysql
API_IMAGE_NAME=dbaas_api
CONDUCTOR_IMAGE_NAME=dbaas_conductor
TASKMANAGER_IMAGE_NAME=dbaas_tm
GUEST_IMAGE_NAME=dbaas_guest

. ${INSTALLER_HOME}/helper/build_image_helper
. ${INSTALLER_HOME}/helper/devstack_helper
. ${INSTALLER_HOME}/helper/git_helper
. ${INSTALLER_HOME}/trove-guestimage-env
. ${INSTALLER_HOME}/helper/create_trove_stack

sudo apt-get install git curl wget -y

install_pip

. ${INSTALLER_HOME}/stackrc/stackrc-admin

nova list

if [ $? -ne 0 ]; then
    install_devstack

    sleep 60
fi


mkdir -p ${IMAGE_DIR}
chmod 777 ${IMAGE_DIR}
chown -R ubuntu:ubuntu ${IMAGE_DIR}

clone_dbaas_git_repos

clone_upstream_git_repos

setup_devstack_env

build_images

create_trove_stack

sleep 900

register_trove_service



