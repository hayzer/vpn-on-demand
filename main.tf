variable "hcloud_token" {
}

variable "location" {
}

variable "ssh_private_key" {
  default = "~/.ssh/id_rsa"
}

data "hcloud_ssh_key" "ssh_public_key" {
  name = "media"
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "vpn" {
  name        = "vpn"
  image       = "ubuntu-18.04"
  server_type = "cx11"
  location    = var.location  
  ssh_keys    = [data.hcloud_ssh_key.ssh_public_key.id]

  connection {
    private_key = "${file(var.ssh_private_key)}"
    host        = "${hcloud_server.vpn.ipv4_address}"
  }

  provisioner "file" {
    source = "server/"
    destination = "/root"
  }
 
  provisioner "remote-exec" {
    inline = ["bash /root/setup.sh"]
  }
}

output "vpn_ip_addr" {
  value = [hcloud_server.vpn.ipv4_address]
}

