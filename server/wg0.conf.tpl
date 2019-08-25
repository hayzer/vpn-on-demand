[Interface]
Address = 192.168.5.1
ListenPort = %%ENDPOINT_PORT%%
PrivateKey = %%SERVER_PRIVATEKEY%%
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = %%CLIENT_PUBLICKEY%%
AllowedIPs = 192.168.5.2/32
