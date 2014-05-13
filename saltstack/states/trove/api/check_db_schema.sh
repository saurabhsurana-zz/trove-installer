#!/bin/bash

mysql -h {{ pillar['trove_mysql_host']}} -u {{ pillar['trove_mysql_username']}} -p{{ pillar['trove_mysql_password']}} -D trove -e "select * from migrate_version"

if [ $? -eq 1 ]; then
   /usr/local/bin/trove-manage --config-file=/etc/trove/trove.conf db_sync

   # create indexes for trove
   mysql -h {{ pillar['trove_mysql_host']}} -u {{ pillar['trove_mysql_username']}} -p{{ pillar['trove_mysql_password']}} -D trove -e "CREATE INDEX \`service_statuses_instance_id\` ON \`service_statuses\` (\`instance_id\`);"
   mysql -h {{ pillar['trove_mysql_host']}} -u {{ pillar['trove_mysql_username']}} -p{{ pillar['trove_mysql_password']}} -D trove -e "CREATE INDEX \`backups_instance_id\` ON \`backups\` (\`instance_id\`);"
   mysql -h {{ pillar['trove_mysql_host']}} -u {{ pillar['trove_mysql_username']}} -p{{ pillar['trove_mysql_password']}} -D trove -e "CREATE INDEX \`backups_deleted\` ON \`backups\` (deleted);"
   mysql -h {{ pillar['trove_mysql_host']}} -u {{ pillar['trove_mysql_username']}} -p{{ pillar['trove_mysql_password']}} -D trove -e "CREATE INDEX \`instances_tenant_id\` ON \`instances\` (\`tenant_id\`);"
   mysql -h {{ pillar['trove_mysql_host']}} -u {{ pillar['trove_mysql_username']}} -p{{ pillar['trove_mysql_password']}} -D trove -e "CREATE INDEX \`instances_deleted\` ON \`instances\` (\`deleted\`);"

else
   echo "Looks like schema is already created"
fi
