resource "ibm_is_security_group" "web_security_group" {
  name           = "${var.name}-web-security-group"
  vpc            = var.vpc
  resource_group = var.resource_group
}


resource "ibm_is_security_group_rule" "web_icmp_in" {
  group     = ibm_is_security_group.web_security_group.id
  direction = "inbound"
  remote    = ibm_is_security_group.wireguard_security_group.id
  icmp {
    code = 8
    type = 0
  }
}

resource "ibm_is_security_group_rule" "web_http_in" {
  group     = ibm_is_security_group.web_security_group.id
  direction = "inbound"
  remote    = ibm_is_security_group.wireguard_security_group.id
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "web_ssh_in" {
  group     = ibm_is_security_group.web_security_group.id
  direction = "inbound"
  remote    = ibm_is_security_group.wireguard_security_group.id
  tcp {
    port_min = 22
    port_max = 22
  }
}


resource "ibm_is_security_group_rule" "web_all_out" {
  group     = ibm_is_security_group.web_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group" "wireguard_security_group" {
  name           = "${var.name}-wg-security-group"
  vpc            = var.vpc
  resource_group = var.resource_group
}

resource "ibm_is_security_group_rule" "wg_port" {
  group     = ibm_is_security_group.wireguard_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 51280
    port_max = 51280
  }
}

resource "ibm_is_security_group_rule" "wg_icmp_in" {
  group     = ibm_is_security_group.wireguard_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  icmp {
    code = 8
    type = 0
  }
}

resource "ibm_is_security_group_rule" "wg_ssh_in" {
  group     = ibm_is_security_group.wireguard_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "wg_all_out" {
  group     = ibm_is_security_group.wireguard_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group" "maintenance_security_group" {
  name           = "${var.name}-maintenance-security-group"
  vpc            = var.vpc
  resource_group = var.resource_group
}


resource "ibm_is_security_group_rule" "maintenance_all_in" {
  group     = ibm_is_security_group.maintenance_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "maintenance_all_out" {
  group     = ibm_is_security_group.maintenance_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}