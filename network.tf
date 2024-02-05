resource "openstack_networking_secgroup_v2" "secgroup" {
    name = "vrrp-test"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "100.120.0.0/21"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_vrrp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "vrrp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "192.168.100/25"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_network_v2" "prod" {
  name           = "terraform_network_prod"
  admin_state_up = "true"
}
resource "openstack_networking_subnet_v2" "prod" {
  name       = "Prod"
  network_id = openstack_networking_network_v2.prod.id
  cidr       = "192.168.100.0/25"
  ip_version = 4
}


resource "openstack_networking_router_v2" "router" {
  name                = "terraform_router"
  admin_state_up      = true
  external_network_id = "35164b56-13a1-4b06-b0e7-94c9a67fef7e"
}
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.prod.id
}