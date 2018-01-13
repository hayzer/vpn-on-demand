#!/bin/bash

terraform apply 
terraform refresh
pass="$(terraform output pass)"
ip="$(terraform output ip)"

echo "scp root@${ip}:/root/client.ovpn ."

