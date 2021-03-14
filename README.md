# Etoa Gameserver Terraform definition

Terraform configuration for setting up EtoA gameservers in Hetzner cloud.

https://console.hetzner.cloud/

Servers are based on Ubuntu 18.04 as this is still maintained and ships with PHP 7.2 which is the currently supported PHP version of EtoA GUI.

## Install terraform

See https://learn.hashicorp.com/tutorials/terraform/install-cli

## Prerequisites

* Have a Hetzner Cloud API token
* Have your SSH key registered in the Hetzner cloud
* Have a floating IP (at location `Nürnberg`) defined for every gameserver
* Mapped the floatings IP to gameserver hostnames in the DNS zone (https://dns.hetzner.com/)

## Create environment

Copy `terraform.tfvars.dist` to `terraform.tfvars` and set your API key in the file.

Run

    terraform init
    terraform plan
    terraform apply

Login with SSH to the server(s) and check `/var/log/cloud-init-output.log` to see if everything has been setup properly.

Visit https//YOUR_HOSTNAME/ to run the initial setup of the web application.
For the database, use `etoa` as user, password and database name. After that:
* Create an admin user
* login to the admin panel
* generate the universe
* start the eventhandler
* setup peroidic tasks
* register the game server at the login site

## Resources

* https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs
* https://cloudinit.readthedocs.io/en/latest/topics/examples.html
* https://stackoverflow.com/questions/34095839/cloud-init-what-is-the-execution-order-of-cloud-config-directives
