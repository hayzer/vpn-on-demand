[Interface]
Address = 192.168.5.2
PrivateKey = %%CLIENT_PRIVATEKEY%%
DNS = 1.1.1.1

[Peer]
Endpoint = %%ENDPOINT_ADDRESS%%:%%ENDPOINT_PORT%%
PublicKey = %%SERVER_PUBLICKEY%%
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
