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

#capturing user data script log
exec > >(tee /var/log/trove-installer-user-data.log | logger -t dbaas-devstack-box -s 2>/dev/console) 2>&1

sudo apt-get update

sudo apt-get install git curl wget -y


#checkout trove-installer repo
cd /home/ubuntu
git clone https://github.com/saurabhsurana/trove-installer

#installing trove control plane with tripleo stack
cd /home/ubuntu/trove-installer/tripleo
sudo ./install.sh
