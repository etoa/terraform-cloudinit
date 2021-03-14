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

resource "hcloud_server" "test01" {
  name = "test01.etoa.net"
  image = "ubuntu-18.04"
  server_type = "cx11"
  location = "nbg1"
  ssh_keys = local.ssh_keys
  user_data = templatefile("cloud_config.yaml", {
    hostname = "test01.etoa.net"
    public_ip = "78.47.232.230"
    webapp_branch = "master"
  })
  firewall_ids = [hcloud_firewall.web_fw.id]
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
