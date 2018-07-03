/*
--------------------------------------------
DNS Host: Terraform Config File
--------------------------------------------
*/

# DATA SOURCES #
data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "ds" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# RESOURCE #
resource "vsphere_virtual_machine" "vm" {
  count            = "${length(var.server_hostname)}"
  name             = "${var.server_hostname[count.index]}.${var.domain}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.ds.id}"

  num_cpus = "${var.cpus}"
  memory   = "${var.memory}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type       = "${data.vsphere_virtual_machine.template.scsi_type}"
  force_power_off = false

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  disk {
    label            = "disk01"
    size             = "${var.disk01[count.index]}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    unit_number      = 1
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostname ${var.server_hostname[count.index]}.${var.domain}",
      "sudo /bin/echo ${var.server_hostname[count.index]}.${var.domain} | sudo tee /etc/hostname",
      "sudo /bin/echo 'DEVICE='eth0'\nNAME='eth0'\nBOOTPROTO='static'\nIPV6INIT='no'\nNM_CONTROLLED='no'\nONBOOT='yes'\nIPADDR=${var.server_ip[count.index]}\nGATEWAY=${var.server_gateway}\nNETMASK='255.255.255.0'\nPEERDNS=no\nDEFROUTE=yes\nIPV4_FAILURE_FATAL=no' | sudo tee /etc/sysconfig/network-scripts/ifcfg-eth0",
      "sudo /usr/bin/systemctl enable sssd",
      "sudo /bin/echo '/usr/local/bin/qca enable' | sudo tee -a /root/on_first_boot.sh",
    ]

    connection {
      type     = "ssh"
      user     = "factory"
      password = "factory"
    }
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${var.server_hostname[count.index]}"
        domain    = "${var.domain}"
      }

      network_interface {
        ipv4_address = "${var.server_ip[count.index]}"
        ipv4_netmask = 24
      }

      ipv4_gateway = "${var.server_gateway}"
    }
  }
}
