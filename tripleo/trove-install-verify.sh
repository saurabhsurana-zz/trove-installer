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

########################################################################
# This script verifies the status of the trove installation
# It verifies following
#   1. Verifies that all the TripleO images are available in glance
#   2. Verifies that Heat Stack is created
#   3. Verifies the nova status of the control plane instances
#
########################################################################

#init log directory
LOG_DIR=/var/log/trove-install-verify/`date +"%m-%d-%Y-%H-%M-%S"`
sudo mkdir -p ${LOG_DIR}
sudo chmod 777 ${LOG_DIR}
sudo chown -R ubuntu:ubuntu ${LOG_DIR}


. /home/ubuntu/trove-installer/utils/colored_echo_helper
. /home/ubuntu/trove-installer/tripleo/stackrc/stackrc-admin


echo "########################################################################"
echo "########################################################################"
echo ""
echo "Trove Environment Status"
echo ""

#verify nova image list
nova image-list > ${LOG_DIR}/nova-image-list 2>&1

if [ $? -eq 0 ]; then
    NOVA_STATUS="RUNNING"
else
    NOVA_STATUS="NOT_FOUND"
fi

echo -n "DevStack / Nova Status : "
coloredEcho ${NOVA_STATUS:-FAILED}
echo ""
echo ""

API_IMAGE_STATUS=`cat ${LOG_DIR}/nova-image-list | grep -i api | awk '{print $6}'`
TM_IMAGE_STATUS=`cat ${LOG_DIR}/nova-image-list | grep -i taskmanager | awk '{print $6}'`
CONDUCTOR_IMAGE_STATUS=`cat ${LOG_DIR}/nova-image-list | grep -i conductor | awk '{print $6}'`
MYSQL_IMAGE_STATUS=`cat ${LOG_DIR}/nova-image-list | grep -i mysql | awk '{print $6}'`
RABBITMQ_IMAGE_STATUS=`cat ${LOG_DIR}/nova-image-list | grep -i rabbitmq | awk '{print $6}'`
GUEST_IMAGE_STATUS=`cat ${LOG_DIR}/nova-image-list | grep -i guest | awk '{print $6}'`

echo "TripleO Image Status:"
echo -n "API_IMAGE_STATUS = "
coloredEcho ${API_IMAGE_STATUS:-FAILED}

echo -n "TM_IMAGE_STATUS = "
coloredEcho ${TM_IMAGE_STATUS:-FAILED}

echo -n "CONDUCTOR_IMAGE_STATUS = "
coloredEcho ${CONDUCTOR_IMAGE_STATUS:-FAILED}

echo -n "MYSQL_IMAGE_STATUS = "
coloredEcho ${MYSQL_IMAGE_STATUS:-FAILED}

echo -n "RABBITMQ_IMAGE_STATUS = "
coloredEcho ${RABBITMQ_IMAGE_STATUS:-FAILED}

echo -n "GUEST_IMAGE_STATUS = "
coloredEcho "${GUEST_IMAGE_STATUS:-FAILED}"
echo ""
echo ""

#verify heat stack status
heat stack-list > ${LOG_DIR}/heat-stack-list 2>&1

HEAT_STACK_STATUS=`cat ${LOG_DIR}/heat-stack-list | grep trove | awk '{print $6}'`

HEAT_STACK_STATUS=`cat ${LOG_DIR}/heat-stack-list | grep trove | awk '{print $6}'`

echo "TripleO Heat Stack Status:"
echo -n "HEAT STACK STATUS = "
coloredEcho ${HEAT_STACK_STATUS:-FAILED}
echo ""
echo ""

#verify nova instance status
nova list > ${LOG_DIR}/nova-stack-list 2>&1

API_NOVA_STATUS=`cat ${LOG_DIR}/nova-stack-list | grep API | awk '{print $6}'`
TM_NOVA_STATUS=`cat ${LOG_DIR}/nova-stack-list | grep TM | awk '{print $6}'`
CONDUCTOR_NOVA_STATUS=`cat ${LOG_DIR}/nova-stack-list | grep Conductor | awk '{print $6}'`
MYSQL_NOVA_STATUS=`cat ${LOG_DIR}/nova-stack-list | grep MySQL | awk '{print $6}'`
RABBITMQ_NOVA_STATUS=`cat ${LOG_DIR}/nova-stack-list | grep RabbitMQ | awk '{print $6}'`


echo "Nova Instances Status:"
echo -n "API_NOVA_STATUS = "
coloredEcho ${API_NOVA_STATUS:-FAILED}

echo -n "TM_NOVA_STATUS = "
coloredEcho ${TM_NOVA_STATUS:-FAILED}

echo -n "CONDUCTOR_NOVA_STATUS = "
coloredEcho ${CONDUCTOR_NOVA_STATUS:-FAILED}

echo -n "MYSQL_NOVA_STATUS = "
coloredEcho ${MYSQL_NOVA_STATUS:-FAILED}

echo -n "RABBITMQ_NOVA_STATUS = "
coloredEcho ${RABBITMQ_NOVA_STATUS:-FAILED}
echo ""
echo ""

trove list > ${LOG_DIR}/trove-list 2>&1
if [ $? -eq 0 ]; then
    TROVE_STATUS="RUNNING"
else
    TROVE_STATUS="NOT_FOUND"
fi

echo -n "Trove Service Status : "
coloredEcho ${TROVE_STATUS:-FAILED}
echo ""
echo ""

#exit by calling a shell to open for the ssh session
/bin/bash