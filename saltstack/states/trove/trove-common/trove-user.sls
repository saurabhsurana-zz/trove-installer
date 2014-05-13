/home/trove:
  file.directory:
    - makedirs: True

trove-group:
  group.present:
    - name: trove

trove-user:
  user.present:
    - name: trove
    - shell: /bin/bash
    - home: /home/trove
    - groups:
      - trove
    - require:
      - group: trove-group
      - file: /home/trove
