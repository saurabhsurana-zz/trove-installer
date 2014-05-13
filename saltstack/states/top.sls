base:
  'trove-salt-box.dbaas-internal':
    - trove-salt-box

  '.*(api|trove-salt-box).*\.dbaas-internal':
    - match: pcre
    - trove.api

  '.*(taskmanager|tm|trove-salt-box).*\.dbaas-internal':
    - match: pcre
    - trove.taskmanager

  '.*(conductor|tm|trove-salt-box).*\.dbaas-internal':
    - match: pcre
    - trove.conductor

  '*.mysql-instance':
    - trove.guestagent
