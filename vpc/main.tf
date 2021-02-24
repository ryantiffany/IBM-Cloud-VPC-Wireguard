resource ibm_is_vpc vpc {
  name           = "${var.name}-vpc"
  resource_group = var.resource_group
  tags           = concat(var.tags)
}


