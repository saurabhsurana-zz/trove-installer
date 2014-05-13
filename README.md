trove-installer
===============

This project provides scripts for setting up a trove service/deployment.
It provides some samples on how to use either a tripleo based deployment approach or a salt stack based deployment.

In future this will also contain a combined approach where tripleo will be used for baking up the complete images for the trove service and salt stack will help in remote execution. The only gray area there is, who handles the configuration management and why!


## tripleo
These contains scripts for installing trove with tripleo.
* helper : Some helper scripts for stuff like clone github repo, create trove users or service registration
* stackrc : credentials for various users
* install.sh : script that setups devstack, build tripleo images for trove control plane and stand up trove stack with heat
* user-data.sh : script that can be used as user_data on nova boot 

## saltstack
This contains scripts for installing trove with salt stack
* states : SaltStack state configuration scripts
* pillar : Pillar configuration
* guest-salt-elements : Disk image builder elements to help build a trove-guestagent


