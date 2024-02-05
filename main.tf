resource "openstack_networking_port_v2" "port_1" {
  name           = "port_1"
  network_id     = openstack_networking_network_v2.prod.id
  admin_state_up = "true"
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.prod.id
    ip_address = "192.168.100.10"
  }

  allowed_address_pairs {
    ip_address = "192.168.100.15"
  }
}
resource "openstack_networking_port_v2" "port_2" {
  name           = "port_2"
  network_id     = openstack_networking_network_v2.prod.id
  admin_state_up = "true"
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.prod.id
    ip_address = "192.168.100.11"
  }

  allowed_address_pairs {
    ip_address = "192.168.100.15"
  }
}

resource "openstack_networking_floatingip_v2" "floating" {
  pool = "europe-se-1-1a-net0"
}

resource "openstack_networking_port_v2" "port_vip" {
  name           = "port_vip"
  network_id     = openstack_networking_network_v2.prod.id
  admin_state_up = "true"
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.prod.id
    ip_address = "192.168.100.15"
  }
}

resource "openstack_networking_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.floating.address
  port_id     = openstack_networking_port_v2.port_vip.id
}


resource "openstack_compute_instance_v2" "instance_1" {
  name            = "web-01"
  flavor_name     = "gp.1x2"
  user_data       = data.template_cloudinit_config.server_1.rendered
  block_device {
    uuid                  = "f74c2365-94fa-4a0d-924d-053074c4c57c" // ubuntu 22
    source_type           = "image"
    volume_size           = 20
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
  network {
    port = openstack_networking_port_v2.port_1.id
  }
}

resource "openstack_networking_port_secgroup_associate_v2" "port_1" {
  port_id = openstack_networking_port_v2.port_1.id
  security_group_ids = [
    openstack_networking_secgroup_v2.secgroup.id
  ]
}

resource "openstack_compute_instance_v2" "instance_2" {
  name            = "web-02"
  flavor_name     = "gp.1x2"
  user_data       = data.template_cloudinit_config.server_2.rendered
  block_device {
    uuid                  = "f74c2365-94fa-4a0d-924d-053074c4c57c" // ubuntu 22
    source_type           = "image"
    volume_size           = 20
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
  network {
    port = openstack_networking_port_v2.port_2.id
  }
}

resource "openstack_networking_port_secgroup_associate_v2" "port_2" {
  port_id = openstack_networking_port_v2.port_2.id
  security_group_ids = [
    openstack_networking_secgroup_v2.secgroup.id
  ]
}

output "public_ip" {
    value = openstack_networking_floatingip_v2.floating.address
}
