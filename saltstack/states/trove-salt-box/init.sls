/opt/scripts/services/salt-key-manage/salt-key-manage.py:
  file.managed:
    - source: salt://trove-salt-box/salt-key-manage.py
    - mode: 755

/etc/init/salt-key-manage.conf:
  file.managed:
    - source: salt://trove-salt-box/salt-key-manage.conf
    - template: jinja
    - user: root
    - mode: 644
    - require:
      - file: /opt/scripts/services/salt-key-manage/salt-key-manage.py

salt-key-manage:
  service:
    - running
    - require:
      - file: /etc/init/salt-key-manage.conf
    - watch:
      - file: /etc/init/salt-key-manage.conf
      - file: /opt/scripts/services/salt-key-manage/salt-key-manage.py

