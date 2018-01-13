// Configure the Vultr provider.

// Find the OS ID for applications.
data "vultr_os" "application" {
  filter {
    name   = "family"
    values = ["application"]
  }
}

// Find the application ID for OpenVPN.
data "vultr_application" "openvpn" {
  filter {
    name   = "short_name"
    values = ["openvpn"]
  }
}

// Find the ID of the Silicon Valley region.
data "vultr_region" "london" {
  filter {
    name   = "name"
    values = ["London"]
  }
}

// Find the ID for a starter plan.
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

// Create a Vultr virtual machine.
resource "vultr_instance" "openvpn" {
  name           = "openvpn"
  hostname       = "openvpn"
  region_id      = "${data.vultr_region.london.id}"
  plan_id        = "${data.vultr_plan.starter.id}"
  os_id          = "${data.vultr_os.application.id}"
  application_id = "${data.vultr_application.openvpn.id}"
 
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

output "pass" {
  value = ["${vultr_instance.openvpn.default_password}"]
}
