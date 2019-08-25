### NOTE: this solution does not provide a real security. Do not use it in any production system. 

##### (it's just convinence and pretty cheap way to set temporary VPN connection)

#### Prerequisites

1. Create [Hetzner](https://www.hetzner.com) account. 
2. Create Hetzner cloud project
3. Upload your ssh public key and generate token for this project. 
4. Set environment variable TF_VAR_hcloud_token=<your new token>.
5. Install [Terraform](https://www.terraform.io/downloads.html).
6. Install [Wireguard](https://www.wireguard.com/install).

#### Create VPN server, connect to and set accordingly your local network

```
 $> ./run.sh start
```
#### Delete VPN configuration and server

```
 $> ./run.sh stop
```

##### Tested only on Linux Mint.

Q&A

Q: Server creation failed with the follow:

```
Error: timeout - last error: dial tcp <IP ADDRESS>:22: connect: connection refused
```

A: Run

```
./run.sh stop
./run.sh start
```
