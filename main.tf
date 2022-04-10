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
  ssh_keys = ["mrcage", "glaubinix"]
  location = "nbg1"
}

provider "hcloud" {
  token = var.hcloud_token
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

resource "hcloud_server" "round20" {
  name = "round20.etoa.net"
  image = "ubuntu-18.04"
  server_type = "cx11"
  location = local.location
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
  location = local.location
  format = "ext4"
}

resource "hcloud_volume_attachment" "round20_data" {
  volume_id = hcloud_volume.round20_data.id
  server_id = hcloud_server.round20.id
}

resource "hcloud_server" "test" {
  name = "test.etoa.net"
  image = "ubuntu-18.04"
  server_type = "cx11"
  location = local.location
  ssh_keys = local.ssh_keys
  user_data = templatefile("cloud_config.yaml", {
    hostname = "test.etoa.net"
    public_ip = "116.202.178.35" # todo test doesn't have the floating IP anymore
    webapp_branch = "master"
    data_disk = hcloud_volume.test_data.linux_device
  })
  firewall_ids = [hcloud_firewall.web_fw.id]
  depends_on = [
    hcloud_volume.test_data,
  ]
}

resource "hcloud_volume" "test_data" {
  name = "test-data"
  size = 10
  location = local.location
  format = "ext4"
}

resource "hcloud_volume_attachment" "test_data" {
  volume_id = hcloud_volume.test_data.id
  server_id = hcloud_server.test.id
}


resource "hcloud_server" "round21" {
  name = "round21.etoa.net"
  image = "ubuntu-18.04"
  server_type = "cx11"
  location = local.location
  ssh_keys = local.ssh_keys
  user_data = templatefile("cloud_config.yaml", {
    hostname = "round21.etoa.net"
    public_ip = "116.202.178.35"
    webapp_branch = "3.6-stable"
    data_disk = hcloud_volume.round21_data.linux_device
  })
  firewall_ids = []
  depends_on = [
    hcloud_volume.round21_data,
  ]
}

resource "hcloud_volume" "round21_data" {
  name = "round21-data"
  size = 10
  location = local.location
  format = "ext4"
}

resource "hcloud_volume_attachment" "round21_data" {
  volume_id = hcloud_volume.round21_data.id
  server_id = hcloud_server.round21.id
}
