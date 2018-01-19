### NOTE: this solution does not provide a real security. Do not use it in any production system. 

##### (it's just convinence and pretty cheap way to set temporary VPN connection)

#### Prerequisites

1. Existing Vultr account. VULTR_API_KEY must be in the environment.
2. Install [Terraform](www.terraform.io/downloads.html).
3. Install openvpn client.
4. Upload your public ssh key to Vultr.
5. Install Vultr [provider](https://github.com/squat/terraform-provider-vultr) for Terraform.


#### Create VPN server and openvpn client connection

```
 $> ./run.sh start
```

##### (Press CTRL-C to stop the VPN client when done)

#### Delete VPN server

```
 $> ./run.sh stop
```

##### Tested only on Linux Mint.

