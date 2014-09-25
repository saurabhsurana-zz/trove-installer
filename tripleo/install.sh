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


#if [ "$(id -u)" != "0" ]; then
#   echo "Install trove-salt-box Log: This script must be run as root" 1>&2
#   exit 1
#fi

CURRENT_TIME=`date +"%m-%d-%y-%H-%M"`
export LOG_DIR=/var/log/trove-installer/${CURRENT_TIME}
sudo mkdir -p ${LOG_DIR}
sudo chmod 777 ${LOG_DIR}
sudo chown -R ${HOST_USER}:${HOST_USER} ${LOG_DIR}


export INSTALLER_HOME=$(dirname $(readlink -f $0))
export IMAGE_DIR=${INSTALLER_HOME}/../../tripleo-image-elements/images
export DEVSTACK_HOME=${INSTALLER_HOME}/../../devstack
export STACK_HOME=${INSTALLER_HOME}/../../stack

. ${INSTALLER_HOME}/install_env.sh

. ${INSTALLER_HOME}/helper/build_image_helper
. ${INSTALLER_HOME}/helper/devstack_helper
. ${INSTALLER_HOME}/helper/git_helper
. ${INSTALLER_HOME}/trove-guestimage-env
. ${INSTALLER_HOME}/helper/create_trove_stack

echo "Installing necessary dependencies"
sudo apt-get install git curl wget -y > /dev/null 2>&1

install_pip

. ${INSTALLER_HOME}/stackrc/stackrc-admin

nova list > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Installing Devstack"
    install_devstack

    sleep 60
fi

echo "Devstack is running"

clone_dbaas_git_repos

clone_upstream_git_repos

setup_devstack_env

build_images

create_trove_stack

register_trove_service



