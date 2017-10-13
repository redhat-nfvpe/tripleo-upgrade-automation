#!/bin/bash
source /home/stack/stackrc

openstack role create _member_
openstack role add --user admin --project admin _member_

