#!/bin/bash

sleep 15 # Wait for the interface
export PATH=$PATH://usr/local/openvpn_as/scripts

sacli --user openvpn --key prop_autologin --value true UserPropPut
sacli --user openvpn GetAutologin > /root/client.ovpn
