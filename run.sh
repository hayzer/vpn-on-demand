#!/bin/bash

VULTR_PUBLIC_KEY=${HOME}/.ssh/id_rsa.pub

REGIONS="Frankfurt London Paris Singapore Dallas Miami Chicago"
VULTR_REGION=$(echo ${REGIONS}|tr ' ' '\n'|shuf -n 1)

case $1 in
    start)
        terraform apply -auto-approve \
            -var vultr_public_key=${VULTR_PUBLIC_KEY} \
            -var vultr_set_region=${VULTR_REGION}
         
        ip="$(terraform output ip)"

        scp -o "StrictHostKeyChecking no" root@${ip}:/root/client.ovpn .
        sudo openvpn --config ./client.ovpn
        ;;
    stop)
        terraform destroy -force \
            -var vultr_public_key=${VULTR_PUBLIC_KEY} \
            -var vultr_set_region=${VULTR_REGION}
        ;;
    *)
	echo "$0 [start|stop]"
esac
   

