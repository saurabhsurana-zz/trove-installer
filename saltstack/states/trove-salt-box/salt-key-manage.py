#!/usr/bin/env python
# Copyright (c) 2014 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import salt.utils.event
import subprocess
import logging
import sys
import os
import time
import MySQLdb as mdb

event = salt.utils.event.MasterEvent('/var/run/salt/master')

logging.basicConfig(level=logging.INFO)
logging.getLogger('salt-key-manage').setLevel(logging.DEBUG)


def _get_trove_db_cursor():
    try:
        con = mdb.connect("127.0.0.1", "root",
                          "e1a2c042c828d3566d0a", "trove")
        return con.cursor()
    except mdb.Error, e:
        print "Error connecting to DB"
        raise e

def accept_Salt_key(key_id):
    salt_command = ['salt-key', '-a', key_id, '-y']
    try:
        logging.debug("Accept Salt Key Command : %s" % salt_command)
        output, error = subprocess.Popen(salt_command,
                                         stdout=subprocess.PIPE,
                                         stderr=subprocess.PIPE).communicate()
        logging.debug("Accept Salt Key Output : %s" % output)
        logging.error("Accept Salt Key Error : %s" % error)
    except:
        logging.debug("Error while accepting key : %s" % key_id)

def check_valid_trove_instance(trove_instance_id, tenant_id):
    try:
        cur = _get_trove_db_cursor()
        #extracting the guest status information, ignoring instances which are deleted
        cur.execute("select deleted from instances where id='%s' and tenant_id='%s'" % (trove_instance_id, tenant_id))

        if cur.rowcount == 0:
            logging.debug("Trove Instance %s or Tenant %s match not found" % (trove_instance_id, tenant_id))
            return False

        rows = cur.fetchall()
        deleted_instance = rows[0][0]
        if deleted_instance == 1:
            logging.debug("Trove Instance %s which belongs Tenant %s is DELETED" % (trove_instance_id, tenant_id))
            return False
        elif deleted_instance == 0:
            logging.debug("Trove Instance %s which belongs Tenant %s is DELETED" % (trove_instance_id, tenant_id))
            return True

        logging.warning("Trove Instance matching Error %s which belongs Tenant %s" % (trove_instance_id, tenant_id))
        return False

    except mdb.Error, e:
        print "Error executing DB Query"
        raise e

    logging.warning("Trove Instance matching Error %s which belongs Tenant" % (trove_instance_id, tenant_id))

for data in event.iter_events(tag='auth'):
    if data['act'] == "pend":
        salt_key_id = data['id']
        if salt_key_id == "trove-salt-box.dbaas-internal":
            logging.debug("Salt Key trove-salt-box.dbaas-internal accepted")
            accept_Salt_key(salt_key_id)
        else:
            print salt_key_id.split('.')
            trove_ins_id = salt_key_id.split('.')[1]
            trove_tenant_id = salt_key_id.split('.')[2]
            logging.debug("Trove ID : %s" % trove_ins_id)
            logging.debug("Tenant ID : %s" % trove_tenant_id)
            if check_valid_trove_instance(trove_ins_id, trove_tenant_id):
                logging.debug("Salt Key %s seems to be from a valid guest instance" % salt_key_id)
                accept_Salt_key(salt_key_id)