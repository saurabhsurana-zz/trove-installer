include:
  - trove.trove-common.dependencies
  - trove.trove-common.trove
  - trove.trove-common.trove-user

/etc/trove:
  file.directory:
    - user: trove
    - group: trove
    - mode: 755
    - makedirs: True
    - require:
      - user: trove-user

/var/log/trove:
  file.directory:
    - user: trove
    - group: trove
    - require:
      - user: trove-user

trove-git:
  git.latest:
    - name: git://github.com/openstack/trove.git
    - target: /opt/stack/trove
    - rev: master

trove-integration-git:
  git.latest:
    - name: git://github.com/openstack/trove-integration.git
    - target: /opt/stack/trove-integration
    - rev: master

diskimage-builder-git:
  git.latest:
    - name: git://github.com/openstack/diskimage-builder.git
    - target: /opt/stack/diskimage-builder
    - rev: master

tripleo-image-elements-git:
  git.latest:
    - name: git://github.com/saurabhsurana/tripleo-image-elements
    - target: /opt/stack/tripleo-image-elements
    - rev: master


trove-install:
  cmd.run:
    - name: python setup.py install
    - cwd: /opt/stack/trove
    - require:
      - pkg: extra_build
      - git: trove-git
      - file: /etc/trove
      - file: /var/log/trove

