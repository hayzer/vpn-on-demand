### Steps


* start vultr openvpn server

 $> ./vultr-vpn

* copy client.vpn to local

 $> scp root@${ip}:/root/client.ovpn .
pass: ${pass}

* run local vpn client

 $> sudo openvpn --config client.ovpn
