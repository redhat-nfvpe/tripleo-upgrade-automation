#!/bin/bash
sudo yum-config-manager --disable rhel-7-server-openstack-9-rpms
sudo yum-config-manager --disable rhel-7-server-openstack-9-director-rpms
sudo yum-config-manager --disable rhel-7-server-rhceph-1.3-osd-rpms
sudo yum-config-manager --disable rhel-7-server-rhceph-1.3-mon-rpms
sudo yum-config-manager --disable rhel-7-server-rhceph-1.3-tools-rpms
