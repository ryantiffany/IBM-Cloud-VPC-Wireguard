resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/templates/inventory.tmpl",
    {
      instances = var.instances
      bastion   = var.bastion
    }
  )
  filename = "${path.module}/inventory"
}

resource "local_file" "ansible-vars" {
  content = templatefile("${path.module}/templates/vars.tmpl",
    {
      region  = var.region
      bastion = var.bastion
    }
  )
  filename = "${path.module}/playbooks/vars.yml"
}

resource "local_file" "wireguard-local-template" {
  content = templatefile("${path.module}/templates/wireguard-client.tmpl",
    {
      subnets       = var.subnets
      cse_addresses = var.cse_addresses
      bastion       = var.bastion
    }
  )
  filename = "${path.module}/templates/wireguard-client.j2"
}

resource "local_file" "ssh-key" {
  content         = var.private_key_pem
  filename        = "${path.module}/generated_key_rsa"
  file_permission = "0600"
}