extra_build:
  pkg.installed:
    - order: 1
    - pkgs:
      - gcc
      - python-dev
      - libxml2-dev
      - libxslt1-dev
{% if 'mysql-instance' in grains['id'] %}
      - libmysqlclient-dev 
{% endif %}
{% if '-api-' in grains['id'] or '-taskmanager-' in grains['id'] or '-tm-' in grains['id']  or 'trove-salt-box' in grains['id'] %}
      - libmysqlclient-dev
      - python-mysqldb
      - mysql-client
{% endif %}


