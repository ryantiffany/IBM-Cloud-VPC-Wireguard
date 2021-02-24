
data ibm_resource_group group {
  name = var.resource_group
}

data "ibm_is_zones" "mzr" {
  region = var.region
}

data ibm_is_vpc vpc {
  count = var.existing_vpc_name != "" ? 1 : 0
  name  = var.existing_vpc_name
}

data ibm_is_ssh_key sshkey {
  count = var.vpc_ssh_key_name != "" ? 1 : 0
  name  = var.vpc_ssh_key_name
}

#
# Retrieve the VPC subnets (so it populates all fields like ipv4_cidr_block)
#
data ibm_is_subnet subnet {
  count      = var.existing_vpc_name != "" ? length(local.vpc.subnets) : 0
  identifier = local.vpc.subnets[count.index].id
}

data ibm_is_subnet existing_subnet {
  count      = var.existing_subnet_id != "" ? 1 : 0
  identifier = var.existing_subnet_id
}

data ibm_is_instances instances {
  count = var.existing_vpc_name != "" ? 1 : 0
}