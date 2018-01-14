### Prerequisites

1. Existing Vultr account. VULTR_API_KEY must be in the environment.
2. Install [Terraform](www.terraform.io/downloads.html).
3. Install openvpn client.
4. Upload your public ssh key to Vultr.
5. Install Vultr [provider](https://github.com/squat/terraform-provider-vultr) for Terraform.


### Create private VPN server and connection

 $> ./run.sh start

### Delete VPN server

 $> ./run.sh stop

