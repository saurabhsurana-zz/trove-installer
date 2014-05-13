#!/bin/bash

# log output from this script to file and syslog
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# debug mode
set -x

sudo service salt-minion stop
sleep 10

chmdo 755 /etc/guest_info

cat > /etc/salt/minion <<EOF
master: 10.0.0.1
EOF

if [ -f /etc/guest_info ]; then
   echo "state_output: mixed" >> /etc/salt/minion

   echo "id: `hostname`" >> /etc/salt/minion

   ins_id=`cat /etc/guest_info  | grep guest_id | cut -d '=' -f2`
   echo ${ins_id}
   datastore_manager=`cat /etc/guest_info  | grep datastore_manager | cut -d '=' -f2`
   echo ${datastore_manager}
   tenant_id=`cat /etc/guest_info  | grep tenant_id | cut -d '=' -f2`
   echo ${tenant_id}
   echo "append_domain: ${ins_id}.${tenant_id}.${datastore_manager}-instance" >> /etc/salt/minion

   echo "" >> /etc/salt/minion
   echo "grains:" >> /etc/salt/minion
   echo "  trove_instance_id: ${ins_id} " >> /etc/salt/minion
   echo "  trove_service_type: ${datastore_manager} " >> /etc/salt/minion
   echo "  trove_tenant_id: ${tenant_id} " >> /etc/salt/minion
fi

sleep 10

sudo service salt-minion start

sleep 10

/home/ubuntu/salt_highstate.sh &


