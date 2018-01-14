#!/bin/bash

VULTR_PUBLIC_KEY=${HOME}/.ssh/id_rsa.pub

case $1 in
    start)
        terraform apply -auto-approve -var vultr_public_key=${VULTR_PUBLIC_KEY}
        ip="$(terraform output ip)"

        scp -o "StrictHostKeyChecking no" root@${ip}:/root/client.ovpn .
        sudo openvpn --config ./client.ovpn
        ;;
    stop)
        terraform destroy -force -var vultr_public_key=${VULTR_PUBLIC_KEY}
        ;;
    *)
	echo "$0 [start|stop]"
esac
   

