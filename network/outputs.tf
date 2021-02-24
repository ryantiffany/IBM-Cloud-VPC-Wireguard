output subnet_id {
  value = ibm_is_subnet.subnet.id
}

output subnet_ipv4_cidr_block {
  value = ibm_is_subnet.subnet.ipv4_cidr_block
}

output public_gateway_id {
  value = ibm_is_public_gateway.gateway.id
}