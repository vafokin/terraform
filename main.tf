terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.2"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.2"
    }
  }
}

resource "random_string" "password" {
  count = length(lookup(var.devs, "prefix"))
  length           = 15
  special          = true
  override_special = "!()-=+:?"
}

provider "aws" {
  region = "eu-central-1"
  access_key = var.aws_access_key 
  secret_key = var.aws_secret_key
  default_tags {
    tags = {
      module = var.module
      mail = var.mail
    }
  }
}

provider "digitalocean" {
  token = var.token
}

resource "digitalocean_tag" "devops" {
  name = var.tag
}

data "digitalocean_ssh_keys" "key" {
  filter {
    key = "public_key"
    values = var.key
  }
}

resource "digitalocean_ssh_key" "my" {
  name       = "SSH Key"
  public_key = var.myKey
}

locals {
  prefix = lookup(var.devs, "prefix")
  logins = lookup(var.devs, "logins")
}

resource "digitalocean_droplet" "do-fwl" {
  count = length(lookup(var.devs, "prefix"))
  image    = "centos-7-x64"
  name     = "${local.logins[count.index]}-${local.prefix[count.index]}"
  region   = "ams3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.my.fingerprint, data.digitalocean_ssh_keys.key.ssh_keys[0].id]
  tags	   = [digitalocean_tag.devops.name]
  connection {
    type     = "ssh"
    user     = "root"
    private_key = file(var.keyfile)
    host     = self.ipv4_address
  }
  provisioner "remote-exec" {
    inline = [
      "echo 'root:${random_string.password[count.index].result}' | chpasswd",
    ]
  }
}

data "aws_route53_zone" "zone" {
  name = "devops.example.srwx.net"
}

resource "aws_route53_record" "www" {
  count = length(lookup(var.devs, "prefix"))
  zone_id = data.aws_route53_zone.zone.zone_id
  name     = "${local.logins[count.index]}-${local.prefix[count.index]}"
  type    = "A"
  ttl     = "300"
  records = [element(digitalocean_droplet.do-fwl.*.ipv4_address, count.index)]
}

resource "local_file" "res" {
  content  = templatefile("templ.tftpl", {lists = {domains = aws_route53_record.www[*].fqdn, ips = digitalocean_droplet.do-fwl[*].ipv4_address, passes = random_string.password[*].result}} )
  filename = "out.txt"
}
