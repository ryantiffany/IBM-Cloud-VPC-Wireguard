output web_security_group {
  value = ibm_is_security_group.web_security_group.id
}

output wireguard_security_group {
  value = ibm_is_security_group.wireguard_security_group.id
}