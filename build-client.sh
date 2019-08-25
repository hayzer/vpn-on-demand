#!/bin/bash

sleep 15 # Wait for the interface. 
export PATH=$PATH:/usr/local/openvpn_as/scripts

CONF=/root/client.ovpn

for i in $(seq 5); do
    if test -s ${CONF};then
        exit 0
    fi
    sacli --user openvpn --key prop_autologin --value true UserPropPut
    sacli --user openvpn GetAutologin > ${CONF}
    sleep 2
done
