terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.25.1"
    }
  }
}

variable "hcloud_token" {}

locals {
  ssh_keys = ["mrcage"]
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "round20" {
  name = "round20.etoa.net"
  image = "ubuntu-18.04"
  server_type = "cx11"
  location = "nbg1"
  ssh_keys = local.ssh_keys
  user_data = templatefile("cloud_config.yaml", {
    hostname = "round20.etoa.net"
    public_ip = "78.47.232.230"
    webapp_branch = "3.6-stable"
    data_disk = hcloud_volume.round20_data.linux_device
  })
  firewall_ids = [hcloud_firewall.web_fw.id]
  depends_on = [
    hcloud_volume.round20_data,
  ]
}

resource "hcloud_volume" "round20_data" {
  name = "round20-data"
  size = 10
  location = "nbg1"
  format = "ext4"
}

resource "hcloud_volume_attachment" "round20_data" {
  volume_id = hcloud_volume.round20_data.id
  server_id = hcloud_server.round20.id
}

resource "hcloud_firewall" "web_fw" {
  name = "web-fw"
  rule {
   direction = "in"
   protocol = "icmp"
   source_ips = [
      "0.0.0.0/0",
      "::/0"
   ]
  }
  rule {
   direction = "in"
   protocol = "tcp"
   port = 22
   source_ips = [
      "0.0.0.0/0",
      "::/0"
   ]
  }
  rule {
   direction = "in"
   protocol = "tcp"
   port = 80
   source_ips = [
      "0.0.0.0/0",
      "::/0"
   ]
  }
  rule {
   direction = "in"
   protocol = "tcp"
   port = 443
   source_ips = [
      "0.0.0.0/0",
      "::/0"
   ]
  }
}
