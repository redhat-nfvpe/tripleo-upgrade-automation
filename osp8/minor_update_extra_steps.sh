#!/bin/bash
source /home/stack/stackrc

for i in $(nova list | awk '/Running/ {print $(NF-1)}' | awk -F"=" '{print $NF}' ) ; do echo $i ; scp -o StrictHostKeyChecking=no /usr/share/openstack-heat-templates/software-config/elements/heat-config/os-refresh-config/configure.d/55-heat-config heat-admin@${i}: ; ssh -o StrictHostKeyChecking=no heat-admin@${i} 'sudo /bin/bash -c "cp /home/heat-admin/55-heat-config /usr/libexec/os-refresh-config/configure.d/55-heat-config"' ; done

for i in $(nova list | awk '/Running/ {print $(NF-1)}' | awk -F"=" '{print $NF}') ; do echo $i ; scp  -o StrictHostKeyChecking=no /usr/share/openstack-heat-templates/software-config/elements/heat-config/bin/heat-config-rebuild-deployed heat-admin@${i}: ; ssh -o StrictHostKeyChecking=no heat-admin@${i} 'sudo /bin/bash -c "mkdir -p /usr/share/openstack-heat-templates/software-config/elements/heat-config/bin ; cp heat-config-rebuild-deployed /usr/share/openstack-heat-templates/software-config/elements/heat-config/bin/heat-config-rebuild-deployed ; chmod +x /usr/share/openstack-heat-templates/software-config/elements/heat-config/bin/heat-config-rebuild-deployed ; /usr/share/openstack-heat-templates/software-config/elements/heat-config/bin/heat-config-rebuild-deployed"' ; done

