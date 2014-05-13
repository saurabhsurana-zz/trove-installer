include:
  - trove.trove-common.dependencies
  - trove.trove-common.trove
  - trove.trove-common.trove-user

/etc/init/trove-api.conf:
  file.managed:
    - source: salt://trove/api/upstart-trove-api.conf
    - template: jinja
    - user: root
    - mode: 644
    - require:
      - cmd: trove-install

/etc/trove/trove.conf:
  file.managed:
    - source: salt://trove/api/trove.conf
    - template: jinja
    - user: trove
    - group: trove
    - mode: 600
    - require:
      - cmd: trove-install

/dbaas/check_db_schema.sh:
  file.managed:
    - source: salt://trove/api/check_db_schema.sh
    - template: jinja
    - user: trove
    - group: trove
    - mode: 755
    - require:
      - cmd: trove-install

      
/etc/trove/api-paste.ini:
  file.managed:
    - source: salt://trove/api/api-paste.ini
    - template: jinja
    - user: trove
    - group: trove
    - mode: 600
    - require:
      - cmd: trove-install

run_db_sync:
  cmd.run:
    - name: /dbaas/check_db_schema.sh
    - user: root
    - require:
      - file: /etc/init/trove-api.conf
      - file: /etc/trove/trove.conf
      - file: /var/log/trove
      - cmd: trove-install

{% if pillar['enable_trove_api_ssl'] %}
/etc/trove/ssl:
  file.directory:
    - makedirs: True
    - user: trove
    - group: trove
    - mode: 755
    - require:
      - cmd: trove-install

/etc/trove/ssl/trove-api.cert:
  file.managed:
    - source: salt://trove/api/ssl_certs/trove-api.cert
    - template: jinja
    - user: trove
    - group: trove
    - mode: 400
    - require:
      - file: /etc/trove/ssl

/etc/trove/ssl/trove-api.key:
  file.managed:
    - source: salt://trove/api/ssl_certs/trove-api.key
    - template: jinja
    - user: trove
    - group: trove
    - mode: 400
    - require:
      - file: /etc/trove/ssl
{% endif %}


trove-api:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/init/trove-api.conf
      - file: /etc/trove/trove.conf
{% if pillar['enable_trove_api_ssl'] %}
      - file: /etc/trove/ssl/trove-api.cert
      - file: /etc/trove/ssl/trove-api.key
{% endif %}