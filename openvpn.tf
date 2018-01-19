variable "vultr_public_key" {}
variable "vultr_set_region" {}

data "vultr_os" "application" {
  filter {
    name   = "family"
    values = ["application"]
  }
}

data "vultr_application" "openvpn" {
  filter {
    name   = "short_name"
    values = ["openvpn"]
  }
}

data "vultr_region" "random_region" {
  filter {
    name   = "name"
    values = ["${var.vultr_set_region}"]
  }
}

data "vultr_plan" "starter" {
  filter {
    name   = "price_per_month"
    values = ["5.00"]
  }

  filter {
    name   = "ram"
    values = ["1024"]
  }
}

resource "vultr_ssh_key" "popcorntime" {
  name       = "popcorntime"
  public_key = "${file("${var.vultr_public_key}")}"
}

// Create a Vultr virtual machine.
resource "vultr_instance" "openvpn" {
  name           = "openvpn"
  hostname       = "openvpn"
  region_id      = "${data.vultr_region.random_region.id}"
  plan_id        = "${data.vultr_plan.starter.id}"
  os_id          = "${data.vultr_os.application.id}"
  application_id = "${data.vultr_application.openvpn.id}"
  ssh_key_ids    = ["${vultr_ssh_key.popcorntime.id}"]
 
  provisioner "file" {
    source = "build-client.sh"
    destination = "/root/build-client.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/build-client.sh",
      "/root/build-client.sh"
    ]
 }
}

output "ip" {
  value = ["${vultr_instance.openvpn.ipv4_address}"]
}
