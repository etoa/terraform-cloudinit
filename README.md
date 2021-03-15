# Etoa Gameserver Terraform definition

[Terraform](https://www.terraform.io/) configuration for setting up EtoA gameservers in the [Hetzner cloud](https://console.hetzner.cloud/).

This project defines the gameserver cloud infrastructure using Terraform.

Servers are based on Ubuntu 18.04 as this is still maintained and ships with PHP 7.2 which is the currently supported PHP version of EtoA GUI.

> Note: Servers can also be created manually and individually; just use the included [cloud_config.yaml](cloud_config.yaml) as [user data](https://cloudinit.readthedocs.io/en/latest/topics/format.html) with any [cloud-init](https://cloud-init.io/) compatible provider. You only need to replace the variables `${...}` with your own values.

## Install terraform

See https://learn.hashicorp.com/tutorials/terraform/install-cli

## Prerequisites

* Have a Hetzner Cloud API token
* Have your SSH key registered in the Hetzner cloud. Check that the name of your SSH key is listed in `main.tf` at `locals` -> `ssh_keys`.
* Have a floating IP (at location `Nürnberg`) defined for every gameserver
* Mapped the floatings IP to gameserver hostnames in the DNS zone (https://dns.hetzner.com/)

## Create environment

Copy `terraform.tfvars.dist` to `terraform.tfvars` and set your API key in the file.

Run

    terraform init
    terraform plan
    terraform apply

Login with SSH to the server(s) and check `/var/log/cloud-init-output.log` to see if everything has been setup properly.

*Make sure the floating IP has been assigned to your servers; you might need to do this manually for now.*

Visit https://YOUR_HOSTNAME/ to run the initial setup of the web application.

In case HTTPS is not working, there might have been an issue with certbot who requests Let's Encrypt SSL certificates. In case your domainname was not resolved (because it has not yet propagated through the DNS system, or the floating IP has not been assigned properly), run certbot again via SSH:

    certbot --apache --agree-tos -m mail@etoa.ch -d YOUR_HOSTNAME --non-interactive --redirect

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
