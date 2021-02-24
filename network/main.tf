resource ibm_is_public_gateway gateway {
  name           = "${var.name}-public-gw"
  vpc            = var.vpc
  zone           = var.zone
  resource_group = var.resource_group
  tags           = var.tags
}

resource ibm_is_subnet subnet {
  name                     = "${var.name}-subnet"
  vpc                      = var.vpc
  zone                     = var.zone
  total_ipv4_address_count = "32"
  network_acl              = var.network_acl
  public_gateway           = ibm_is_public_gateway.gateway.id
  resource_group           = var.resource_group
}