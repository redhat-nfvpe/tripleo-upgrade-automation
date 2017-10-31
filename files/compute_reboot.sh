#!/bin/bash
for NODE in `nova list | grep compute | awk -F "|" '{ print $2 }'` ; do
    NODE_IP=$(openstack server show $NODE -f json  | jq -r .addresses | grep -oP '[0-9.]+')
    NODE_NAME=$(openstack server show $NODE -f json  | jq -r .name)

    echo "Rebooting $NODE_NAME"
    nova reboot $NODE_NAME

    timeout_seconds=480
    elapsed_seconds=0
    while true; do
        echo "Waiting for $NODE_NAME to go down ..."
        NODE_DOWN=$(sudo ping -c1 $NODE_IP)
        EXIT_STATUS=$?
        if [ $EXIT_STATUS != 0 ]; then
            break
        fi
        sleep 3
        (( elapsed_seconds += 3 ))
        if [ $elapsed_seconds -ge $timeout_seconds ]; then
            echo "FAILURE: Node $NODE_NAME didn't reboot in time"
            exit 1
        fi
    done

    ## wait for node to get back online
    elapsed_seconds=0
    while true; do
        echo "Waiting for $NODE boot ..."
        COMPUTE_STATUS=$(ssh -q -o StrictHostKeyChecking=no heat-admin@$NODE_IP 'exit')
        EXIT_CODE=$?
        if [[ $EXIT_CODE == 0 ]]; then
            break
        fi
        sleep 3
        (( elapsed_seconds += 3 ))
        if [ $elapsed_seconds -ge $timeout_seconds ]; then
            echo "FAILURE: $NODE_NAME didn't come back up as part of the cluster"
            exit 1
        fi
    done
done
