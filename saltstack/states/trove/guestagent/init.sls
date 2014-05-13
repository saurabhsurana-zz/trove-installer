include:
  - trove.trove-common.trove-user

/etc/init/trove-guest.conf:
  file.managed:
    - source: salt://trove/guestagent/upstart-trove-guest.conf
    - template: jinja
    - user: root
    - mode: 644
    - require:
      - group: trove-group
      - user: trove-user
      - file: /etc/trove/trove-guestagent.conf

/etc/trove/trove-guestagent.conf:
  file.managed:
    - source: salt://trove/guestagent/trove-guestagent.conf
    - template: jinja
    - user: trove
    - mode: 400
    - require:
      - group: trove-group
      - user: trove-user

/etc/guest_info:
  file.managed:
    - user: trove
    - group: trove
    - mode: 750

/var/log/trove:
  file.directory:
    - user: trove
    - group: trove
    - require:
      - user: trove-user

/var/log/trove/trove-guestagent.log:
  file.managed:
    - user: trove
    - group: trove
    - mode: 644
    - require:
      - file: /var/log/trove

trove-guest:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/trove/trove-guestagent.conf
      - file: /etc/init/trove-guest.conf

