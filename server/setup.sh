#!/bin/bash

# install wireguard
(ps aux|grep -q [a]pt) && killall apt apt-get
sleep 1
add-apt-repository -y ppa:wireguard/wireguard
apt-get -y install wireguard resolvconf
apt-get -y install libmnl-dev libelf-dev linux-headers-$(uname -r) build-essential pkg-config

modprobe wireguard

# to enable kernel relaying/forwarding ability on bounce servers
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.proxy_arp = 1" >> /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf

# to add iptables forwarding rules on bounce servers
#iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i wg0 -o wg0 -m conntrack --ctstate NEW -j ACCEPT
#iptables -t nat -A POSTROUTING -s 10.0.44.0/24 -o eth0 -j MASQUERADE

wg-quick up /root/wg0.conf
wg show
