locals {
  instances = var.existing_vpc_name != "" ? [
    for instance in data.ibm_is_instances.instances.0.instances :
    instance if instance.vpc == local.vpc.id && instance.id != module.wireguard.instance.id
  ] : module.instance[*].instances
}

locals {
  vpc = var.existing_vpc_name != "" ? data.ibm_is_vpc.vpc.0 : module.vpc.0.vpc
}

locals {
  ssh_key_ids = var.vpc_ssh_key_name != "" ? [data.ibm_is_ssh_key.sshkey[0].id, ibm_is_ssh_key.generated_key.id] : [ibm_is_ssh_key.generated_key.id]
}

resource tls_private_key ssh {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource ibm_is_ssh_key generated_key {
  name           = "${var.name}-${var.region}-key"
  public_key     = tls_private_key.ssh.public_key_openssh
  resource_group = data.ibm_resource_group.group.id
  tags           = concat(var.tags, ["region:${var.region}", "vpc:${var.name}-vpc", "provider:ibmcloud", "resource_type:ibm_is_ssh_key"])
}

module vpc {
  count          = var.existing_vpc_name != "" ? 0 : 1
  source         = "./vpc"
  name           = var.name
  resource_group = data.ibm_resource_group.group.id
  tags           = concat(var.tags, ["region:${var.region}", "provider:ibmcloud", "vpc:${var.name}-vpc", "resource_type:ibm_is_vpc"])
}

module network {
  source         = "./network"
  name           = "${var.name}-${data.ibm_is_zones.mzr.zones[0]}"
  zone           = data.ibm_is_zones.mzr.zones[0]
  network_acl    = local.vpc.default_network_acl
  vpc            = local.vpc.id
  resource_group = data.ibm_resource_group.group.id
  tags           = concat(var.tags, ["zone:${data.ibm_is_zones.mzr.zones[0]}", "vpc:${var.name}-vpc", "region:${var.region}", "provider:ibmcloud", "resource_type:ibm_is_public_gateway"])
}

module security {
  source         = "./security"
  name           = var.name
  resource_group = data.ibm_resource_group.group.id
  vpc            = local.vpc.id
  subnet_cidr = module.network.subnet_ipv4_cidr_block
}

module wireguard {
  source         = "./instances"
  vpc            = local.vpc.id
  subnet_id      = module.network.subnet_id
  ssh_key_ids    = local.ssh_key_ids
  resource_group = data.ibm_resource_group.group.id
  name           = "${var.name}-wg"
  zone           = data.ibm_is_zones.mzr.zones[0]
  security_group = module.security.wireguard_security_group
  tags           = concat(var.tags, ["zone:${data.ibm_is_zones.mzr.zones[0]}", "region:${var.region}", "vpc:${var.name}-vpc", "provider:ibmcloud"])
}

module instance {
  count          = "2"
  source         = "./instances"
  vpc            = local.vpc.id
  subnet_id      = module.network.subnet_id
  ssh_key_ids    = local.ssh_key_ids
  resource_group = data.ibm_resource_group.group.id
  name           = "${var.name}-web-${count.index + 1}"
  zone           = data.ibm_is_zones.mzr.zones[0]
  security_group = module.security.web_security_group
  tags           = concat(var.tags, ["zone:${data.ibm_is_zones.mzr.zones[0]}", "region:${var.region}", "vpc:${var.name}-vpc", "provider:ibmcloud"])
}

resource ibm_is_floating_ip wireguard {
  name   = "${var.name}-wireguard-address"
  target = module.wireguard.primary_network_interface_id
}

module ansible {
  source          = "./ansible"
  instances       = module.instance[*].instances
  bastion         = ibm_is_floating_ip.wireguard.address
  region          = var.region
  cse_addresses   = join(", ", flatten(local.vpc.cse_source_addresses[*].address))
  subnets         = join(", ", [format("%s0.0/18", substr(module.network.subnet_ipv4_cidr_block, 0, 7))])
  private_key_pem = tls_private_key.ssh.private_key_pem
}
