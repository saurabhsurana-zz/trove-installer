This is sample salt stack based install/setup for trove (OpenStack's DBaaS) service.

### saltstack
* states : SaltStack state configuration scripts 
* pillar : Pillar configuration 		


### Pillar:
Pillar in salt stack usually refers to the data that you want to able to control/change. Configuration values which are likely to change over a period of time, should go in pillar, things like credentials, tunning parameters, hostname etc.
Pillar directory contains pillar data for configuring trove service (API, TM, Conductor and GuestAgent)

### States:
States in salt stack offers an optional interface to manage the configuration or "state" of the Salt minions. In state we configure things like Package versions, their dependencies, specific configuration file (as Jinja templates to use values from the pillar data).
States directory contains the state configuration for trove services (API, TM, Conductor and GuestAgent).

### Building GuestAgent image
This setup expects two changes to the default trove guest agent image:
1. salt-minion elements from tripleo image elements repository needs to be included in the image building process (tripleo-image-elements/elements/salt-minion). This elements provides 
2. Trove Service needs to be installed in the image (salt states don't install the service). 




