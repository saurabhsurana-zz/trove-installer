include:
  - trove.trove-common.dependencies
  - trove.trove-common.trove
  - trove.trove-common.trove-user

include:
  - pip
  - trove.trove-common.dependancies
  - trove.taskmanager
  - trove.trove-common.trove

/etc/init/trove-conductor.conf:
  file.managed:
    - source: salt://trove/conductor/upstart-trove-conductor.conf
    - template: jinja
    - user: root
    - mode: 600
    - require:
      - cmd: trove-install

/etc/trove/trove-conductor.conf:
  file.managed:
    - source: salt://trove/conductor/trove-conductor.conf
    - template: jinja
    - user: trove
    - group: trove
    - mode: 600
    - require:
      - cmd: trove-install

trove-conductor:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/trove/trove-conductor.conf
      - file: /etc/init/trove-conductor.conf

