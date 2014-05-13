base:
  '*':
    - trove.url

  '.*(api|trove-salt-box).*\.dbaas-internal':
    - match: pcre
    - trove.api
    - trove.api.ssl-api

  '.*(taskmanager|tm|trove-salt-box).*\.dbaas-internal':
    - match: pcre
    - trove.taskmanager

  '.*(conductor|tm|trove-salt-box).*\.dbaas-internal':
    - match: pcre
    - trove.conductor

  '*.mysql-instance':
    - trove.guestagent

