output instance_ips {
  value = [
    for instance in local.instances : instance.primary_network_interface.0.primary_ipv4_address
  ]
}
