#!/bin/bash
export HOST_USER=vagrant

export MYSQL_IMAGE_NAME=mysql
export RABBITMQ_IMAGE_NAME=messaging
export API_IMAGE_NAME=api
export TASKMANAGER_IMAGE_NAME=taskmanager
export CONDUCTOR_IMAGE_NAME=conductor
export GUEST_IMAGE_NAME=guest

#Paths
DEVSTACK_HOME=/home/vagrant/devstack
STACK_HOME=/home/vagrant

DBAAS_HEAT_TEMPLATES=${STACK_HOME}/trove-heat-template
DBAAS_IMAGE_ELEMENTS=${STACK_HOME}/trove-image-elements
TRIPLEO_IMAGE_ELEMENTS=${STACK_HOME}/tripleo-image-elements
DISK_IMAGE_BUILDER=${STACK_HOME}/diskimage-builder
TROVE_INTEGRATION=${STACK_HOME}/trove-integration

LOGFILE=/var/log/dbaas-installer/dbaas-installer.log
DBAAS_IMAGES=${DBAAS_IMAGE_ELEMENTS}/dbaas_images

