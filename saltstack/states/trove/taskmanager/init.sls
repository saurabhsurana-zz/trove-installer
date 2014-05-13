include:
  - trove.trove-common.dependencies
  - trove.trove-common.trove
  - trove.trove-common.trove-user

include:
  - pip
  - trove.trove-common.dependancies
  - trove.trove-common.trove

/etc/init/trove-taskmanager.conf:
  file.managed:
    - source: salt://trove/taskmanager/upstart-trove-taskmanager.conf
    - template: jinja
    - user: root
    - mode: 600
    - require:
      - cmd: trove-install

/etc/trove/trove-taskmanager.conf:
  file.managed:
    - source: salt://trove/taskmanager/trove-taskmanager.conf
    - template: jinja
    - user: trove
    - group: trove
    - mode: 600
    - require:
      - cmd: trove-install


/etc/trove/cloudinit:
  file.directory:
    - user: trove
    - group: trove
    - mode: 755
    - require:
      - cmd: trove-install

/etc/trove/cloudinit/mysql.cloudinit:
  file.managed:
    - source: salt://trove/taskmanager/user_data.sh
    - template: jinja
    - user: trove
    - group: trove
    - mode: 750
    - require:
      - cmd: trove-install

/etc/trove/templates:
  file.directory:
    - user: trove
    - group: trove
    - mode: 755
    - require:
      - cmd: trove-install

/etc/trove/templates/mysql:
  file.directory:
    - user: trove
    - group: trove
    - mode: 755
    - require:
      - cmd: trove-install

/etc/trove/templates/mysql/config.template:
  file.managed:
    - source: salt://trove/taskmanager/mysql.config.template
    - user: trove
    - group: trove
    - mode: 755
    - require:
      - cmd: trove-install

trove-taskmanager:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/trove/trove-taskmanager.conf
      - file: /etc/init/trove-taskmanager.conf

