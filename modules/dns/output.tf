output "ipaddr" {
  value = "${vsphere_virtual_machine.vm.*.default_ip_address}"
}
